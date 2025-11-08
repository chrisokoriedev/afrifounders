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
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

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

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item == null ? AppStrings.addItem : AppStrings.editItem,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            children: [
              CustomTextField(
                label: AppStrings.itemTitle,
                hint: AppStrings.itemTitleHint,
                controller: _titleController,
                validator: Validators.validateTitle,
                maxLength: 100,
              ),
              SizedBox(height: AppDimensions.spacingM),
              CustomTextField(
                label: AppStrings.itemDescription,
                hint: AppStrings.itemDescriptionHint,
                controller: _descriptionController,
                validator: Validators.validateDescription,
                maxLines: 4,
                maxLength: 500,
              ),
              SizedBox(height: AppDimensions.spacingXL),
              CustomButton(
                text: AppStrings.save,
                onPressed: _saveItem,
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

