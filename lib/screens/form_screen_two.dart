import 'package:dynamic_form/models/merchant.dart';
import 'package:dynamic_form/models/merchant_field.dart';
import 'package:dynamic_form/widgets/build_dropdown_field.dart';
import 'package:dynamic_form/widgets/build_text_form_field.dart';
import 'package:dynamic_form/widgets/promo_button.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_form/widgets/account_section.dart';

class FormScreen2 extends StatefulWidget {
  final Merchant merchant;
  const FormScreen2({super.key, required this.merchant});

  @override
  State<FormScreen2> createState() => _FormScreen2State();
}

class _FormScreen2State extends State<FormScreen2> {
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

  Widget _buildField(MerchantField field) {
    Widget fieldWidget;

    switch (field.isinputType.toUpperCase()) {
      case 'DROPDOWN':
        fieldWidget = BuildDropdownField(
          field: field,
          selectedValue: _selectedValues[field.label],
          onChanged: (value) {
            setState(() {
              _selectedValues[field.label] = value;
            });
          },
          validator: (value) {
            if (field.isRequired && (value == null || value.isEmpty)) {
              return '${field.label} is required';
            }
            return null;
          },
        );
        break;

      case 'AMOUNT':
      case 'NUMERIC':
      case 'LANDLINE':
      case 'ESEWAID':
      case 'MOBILE':
        fieldWidget = BuildTextFormField(
          field: field,
          controller:
              _controllers[field
                  .label], // declared Map<String, TextEditingController>
          isAmount: field.isinputType == 'AMOUNT',
          selectedValue:
              _selectedValues[field.label], // declared Map<String, String?>
          onChipSelected: (value) {
            setState(() {
              _selectedValues[field.label] = value;
              _controllers[field.label]?.text = value;
            });
          },
        );
        break;

      case 'TEXT':
      case 'STRING':
      case 'REGEX':
      default:
        fieldWidget = BuildTextFormField(
          field: field,
          controller:
              _controllers[field
                  .label], // declared Map<String, TextEditingController>
          isAmount: field.isinputType == 'AMOUNT',
          selectedValue:
              _selectedValues[field.label], // declared Map<String, String?>
          onChipSelected: (value) {
            setState(() {
              _selectedValues[field.label] = value;
              _controllers[field.label]?.text = value;
            });
          },
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        fieldWidget,
        SizedBox(height: 20),
      ],
    );
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
              child: Column(
                children: [
                  AccountSection(),
                  SizedBox(height: 20),
                  Expanded(
                    // ✅ THIS FIXES ListView inside Column
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          ...widget.merchant.sortedFields.map(
                            (field) => _buildField(field),
                          ),
                          PromoButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
