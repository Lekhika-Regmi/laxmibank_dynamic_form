import 'package:flutter/material.dart';
import '../models/merchant_field.dart';

class BuildTextFormField extends StatelessWidget {
  final MerchantField field;
  final TextEditingController? controller;
  final String? selectedValue;
  final void Function(String)? onChipSelected;
  final bool isAmount;

  const BuildTextFormField({
    super.key,
    required this.field,
    this.controller,
    this.selectedValue,
    this.onChipSelected,
    this.isAmount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: field.placeHolder.isNotEmpty
                ? field.placeHolder
                : 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: field.label.toLowerCase().contains('id')
                ? const Icon(Icons.contact_page_outlined, color: Color(0xffEF7D17))
                : null,
          ),
          keyboardType: _getKeyboardType(field.isinputType),
          validator: (value) {
            if (field.isRequired && (value?.isEmpty ?? true)) {
              return '${field.label} is required';
            }
            if (field.regex.isNotEmpty &&
                value != null &&
                value.isNotEmpty &&
                !RegExp(field.regex).hasMatch(value)) {
              return 'Invalid ${field.label.toLowerCase()} format';
            }
            return null;
          },
        ),

        // Optional Chip Selector
        if (isAmount && field.options.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: field.options.map((option) {
              return ChoiceChip(
                label: Text(option.label),
                selected: selectedValue == option.value,
                onSelected: (selected) {
                  if (selected) onChipSelected?.call(option.value);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  TextInputType _getKeyboardType(String inputType) {
    switch (inputType.toUpperCase()) {
      case 'NUMERIC':
      case 'AMOUNT':
      case 'MOBILE':
      case 'LANDLINE':
        return TextInputType.number;
      case 'EMAIL':
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}
