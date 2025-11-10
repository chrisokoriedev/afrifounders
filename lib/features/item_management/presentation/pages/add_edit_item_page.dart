import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/item.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../providers/item_notifier.dart';

/// Page for adding or editing an item
class AddEditItemPage extends ConsumerStatefulWidget {
  final Item? item;

  const AddEditItemPage({
    super.key,
    this.item,
  });

  @override
  ConsumerState<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends ConsumerState<AddEditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _clientNameFocusNode = FocusNode();
  final _timeEstimateFocusNode = FocusNode();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _clientNameController;
  late final TextEditingController _timeEstimateController;
  String? _selectedTimeOfDay;
  DateTime? _scheduledDate;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _clientNameController = TextEditingController(
      text: widget.item?.clientName ?? '',
    );
    _timeEstimateController = TextEditingController(
      text: widget.item?.timeEstimateMinutes != null
          ? widget.item!.timeEstimateMinutes.toString()
          : '',
    );
    _selectedTimeOfDay = widget.item?.timeOfDay;
    _scheduledDate = widget.item?.scheduledDate;
    
    // Track changes for unsaved changes warning
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _clientNameController.addListener(_onFieldChanged);
    _timeEstimateController.addListener(_onFieldChanged);
    
    // Auto-focus title field after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _clientNameFocusNode.dispose();
    _timeEstimateFocusNode.dispose();
    _titleController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);
    _clientNameController.removeListener(_onFieldChanged);
    _timeEstimateController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    _clientNameController.dispose();
    _timeEstimateController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Don't allow pop while loading
    if (_isLoading) {
      return false;
    }

    // Allow pop if no unsaved changes
    if (!_hasUnsavedChanges) {
      return true;
    }

    // Show confirmation dialog if there are unsaved changes
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.unsavedChanges),
        content: const Text(AppStrings.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.discard),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  void _dismissKeyboard() {
    _titleFocusNode.unfocus();
    _descriptionFocusNode.unfocus();
    _clientNameFocusNode.unfocus();
    _timeEstimateFocusNode.unfocus();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _scheduledDate = picked;
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _saveItem() async {
    // Dismiss keyboard
    _dismissKeyboard();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final clientName = _clientNameController.text.trim();
    final timeEstimateText = _timeEstimateController.text.trim();
    final timeEstimateMinutes = timeEstimateText.isNotEmpty
        ? int.tryParse(timeEstimateText)
        : null;

    try {
      if (widget.item == null || widget.item!.id.isEmpty) {
        // Add new item - create item and use updateItem (which handles both add and update)
        final now = DateTime.now();
        final item = Item(
          id: const Uuid().v4(),
          title: title,
          description: description.isEmpty ? null : description,
          createdAt: now,
          updatedAt: now,
          clientName: clientName.isEmpty ? null : clientName,
          timeEstimateMinutes: timeEstimateMinutes,
          timeOfDay: _selectedTimeOfDay,
          scheduledDate: _scheduledDate,
        );
        // Use updateItem which will handle adding if it doesn't exist
        await ref.read(itemNotifierProvider.notifier).updateItem(item);
      } else {
        // Update existing item
        final updatedItem = widget.item!.copyWith(
          title: title,
          description: description.isEmpty ? null : description,
          clientName: clientName.isEmpty ? null : clientName,
          timeEstimateMinutes: timeEstimateMinutes,
          timeOfDay: _selectedTimeOfDay,
          scheduledDate: _scheduledDate,
        );
        await ref.read(itemNotifierProvider.notifier).updateItem(updatedItem);
      }

      // Check for errors in state
      final state = ref.read(itemNotifierProvider);
      if (state.error != null && mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(state.error!.message);
        return;
      }

      // Success
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasUnsavedChanges = false;
        });
        _showSuccessSnackBar();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(
          widget.item == null
              ? AppStrings.errorAddingItem
              : AppStrings.errorUpdatingItem,
        );
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              widget.item == null
                  ? AppStrings.itemAddedSuccessfully
                  : AppStrings.itemUpdatedSuccessfully,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onError,
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: AppStrings.retry,
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: _saveItem,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.item == null ? AppStrings.addItem : AppStrings.editItem,
          ),
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        body: GestureDetector(
          onTap: _dismissKeyboard,
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                children: [
                  // Title field
                  CustomTextField(
                    label: AppStrings.itemTitle,
                    hint: AppStrings.itemTitleHint,
                    controller: _titleController,
                    validator: Validators.validateTitle,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    focusNode: _titleFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _descriptionFocusNode.requestFocus();
                    },
                  ),
                  SizedBox(height: AppDimensions.spacingL),
                  
                  // Description field
                  CustomTextField(
                    label: AppStrings.itemDescription,
                    hint: AppStrings.itemDescriptionHint,
                    controller: _descriptionController,
                    validator: Validators.validateDescription,
                    maxLines: 4,
                    maxLength: 500,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    textInputAction: TextInputAction.newline,
                  ),
                  SizedBox(height: AppDimensions.spacingL),

                  // Client name field
                  CustomTextField(
                    label: 'Client/Project',
                    hint: 'e.g., coinbase, apple, shopify',
                    controller: _clientNameController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    focusNode: _clientNameFocusNode,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                  SizedBox(height: AppDimensions.spacingL),

                  // Time of day selector
                  DropdownButtonFormField<String>(
                    value: _selectedTimeOfDay,
                    decoration: InputDecoration(
                      labelText: 'Time of Day',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      prefixIcon: const Icon(Icons.schedule),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'morning', child: Text('Morning')),
                      DropdownMenuItem(value: 'afternoon', child: Text('Afternoon')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeOfDay = value;
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),
                  SizedBox(height: AppDimensions.spacingL),

                  // Time estimate field
                  CustomTextField(
                    label: 'Time Estimate (minutes)',
                    hint: 'e.g., 30, 45, 60',
                    controller: _timeEstimateController,
                    keyboardType: TextInputType.number,
                    focusNode: _timeEstimateFocusNode,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.timer_outlined),
                  ),
                  SizedBox(height: AppDimensions.spacingL),

                  // Scheduled date picker
                  InkWell(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Scheduled Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _scheduledDate != null
                            ? DateFormat('EEEE, MMM d, y').format(_scheduledDate!)
                            : 'Select a date',
                        style: TextStyle(
                          color: _scheduledDate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingXL),
                  
                  // Save button
                  CustomButton(
                    text: AppStrings.save,
                    onPressed: _isLoading ? null : _saveItem,
                    isLoading: _isLoading,
                    icon: Icons.save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

