import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/merchant.dart';
import '../models/merchant_field.dart';

class FormScreen extends StatefulWidget {
  final Merchant merchant;

  const FormScreen({super.key, required this.merchant});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    for (var field in widget.merchant.sortedFields) {
      _controllers[field.label] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEF7D17),
      appBar: AppBar(
        title: Text(widget.merchant.name.toUpperCase()),
        backgroundColor: Color(0xffEF7D17),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // From Account Section (Static for now)
                    _buildFromAccountSection(),

                    SizedBox(height: 20),

                    // Dynamic fields based on merchant configuration
                    ...widget.merchant.sortedFields.map(
                      (field) => _buildField(field),
                    ),

                    SizedBox(height: 20),

                    // Apply Promo Code Button
                    _buildPromoCodeButton(),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Bottom buttons
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffEF7D17),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFromAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Account',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'XXX XXX.XX',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.visibility_off,
                          size: 16,
                          color: Colors.grey,
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffEF7D17),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Primary',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('XXXX', style: TextStyle(color: Colors.grey[600])),
                    Text(
                      'XXXXXXXXX',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(MerchantField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        field.hasOptions
            ? _buildDropdownField(field)
            : _buildTextFormField(field),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextFormField(MerchantField field) {
    // Special handling for amount field to show info icon and choice chips
    bool isAmountField = field.label.toLowerCase().contains('amount');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controllers[field.label],
                maxLength: field.maxLength > 0 ? field.maxLength : null,
                keyboardType: _getKeyboardType(field.inputType),
                inputFormatters: _getInputFormatters(field),
                decoration: InputDecoration(
                  hintText: field.placeHolder.isNotEmpty
                      ? field.placeHolder
                      : 'Enter ${field.label.toLowerCase()}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.all(15),
                  counterText: '',
                  suffixIcon: field.label.toLowerCase().contains('id')
                      ? Icon(
                          Icons.contact_page_outlined,
                          color: Color(0xffEF7D17),
                        )
                      : null,
                ),
                validator: (value) {
                  if (field.isRequired && (value?.isEmpty ?? true)) {
                    return '${field.label} is required';
                  }
                  if (field.regex.isNotEmpty &&
                      value != null &&
                      value.isNotEmpty) {
                    if (!RegExp(field.regex).hasMatch(value)) {
                      return 'Invalid ${field.label.toLowerCase()} format';
                    }
                  }
                  return null;
                },
              ),
            ),
            if (isAmountField) ...[
              SizedBox(width: 10),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xffEF7D17).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.info_outline, color: Color(0xffEF7D17)),
              ),
            ],
          ],
        ),
        // Show choice chips for amount field if it has options
        if (isAmountField && field.hasOptions) ...[
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: field.options
                  .map(
                    (option) => Container(
                      margin: EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(option.label),
                        selected: _selectedValues[field.label] == option.value,
                        selectedColor: Color(0xffEF7D17).withOpacity(0.2),
                        backgroundColor: Color(0xffEF7D17).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _selectedValues[field.label] == option.value
                              ? Color(0xffEF7D17)
                              : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedValues[field.label] = option.value;
                              _controllers[field.label]!.text = option.value;
                            }
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField(MerchantField field) {
    return DropdownButtonFormField<String>(
      value: _selectedValues[field.label],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: EdgeInsets.all(15),
      ),
      hint: Text(
        '${field.placeHolder.isNotEmpty ? field.placeHolder : field.label}',
      ),
      items: field.options
          .map(
            (option) => DropdownMenuItem(
              value: option.value,
              child: Text(option.label),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedValues[field.label] = value;
        });
      },
      validator: (value) {
        if (field.isRequired && value == null) {
          return '${field.label} is required';
        }
        return null;
      },
    );
  }

  Widget _buildPromoCodeButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Handle promo code
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Apply Promo Code',
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      ),
    );
  }

  TextInputType _getKeyboardType(String inputType) {
    switch (inputType.toLowerCase()) {
      case 'number':
      case 'numeric':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters(MerchantField field) {
    List<TextInputFormatter> formatters = [];

    if (field.inputType.toLowerCase() == 'number' ||
        field.inputType.toLowerCase() == 'numeric') {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (field.maxLength > 0) {
      formatters.add(LengthLimitingTextInputFormatter(field.maxLength));
    }

    return formatters;
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      Map<String, String> formData = {};

      // Add field values
      for (var field in widget.merchant.sortedFields) {
        if (field.hasOptions) {
          if (_selectedValues[field.label] != null) {
            formData[field.label] = _selectedValues[field.label]!;
          }
        } else {
          if (_controllers[field.label]?.text.isNotEmpty ?? false) {
            formData[field.label] = _controllers[field.label]!.text;
          }
        }
      }

      print('Form Data: $formData');
      // TODO: Submit to API

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Form submitted successfully!')));
    }
  }

}

