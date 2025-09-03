import 'package:flutter/material.dart';
import '../models/merchant_field.dart';

class BuildDropdownField extends StatelessWidget {
  final MerchantField field;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const BuildDropdownField({
    Key? key,
    required this.field,
    required this.selectedValue,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: EdgeInsets.all(15),
      ),
      hint: Text(
        field.placeHolder.isNotEmpty
            ? field.placeHolder
            : 'Select ${field.label.toLowerCase()}',
      ),
      items: field.options.map((option) {
        return DropdownMenuItem<String>(
          value: option.value,
          child: Text(option.label),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
