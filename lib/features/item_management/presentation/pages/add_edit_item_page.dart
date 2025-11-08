import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    
    // Track changes for unsaved changes warning
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    
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
    _titleController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _descriptionController.dispose();
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

    try {
      if (widget.item == null) {
        // Add new item
        await ref.read(itemNotifierProvider.notifier).addItem(
              title,
              description: description.isEmpty ? null : description,
            );
      } else {
        // Update existing item
        final updatedItem = widget.item!.copyWith(
          title: title,
          description: description.isEmpty ? null : description,
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

