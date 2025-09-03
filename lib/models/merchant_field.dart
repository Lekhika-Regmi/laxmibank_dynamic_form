import 'field_option.dart';

class MerchantField {
  final String label;
  final int paramOrder;
  final int maxLength;
  final String regex;
  final String inputType;
  final String required;
  final String placeHolder;
  final String? unicodeLabel;
  final List<FieldOption> options;

  MerchantField({
    required this.label,
    required this.paramOrder,
    required this.maxLength,
    required this.regex,
    required this.inputType,
    required this.required,
    required this.placeHolder,
    this.unicodeLabel,
    required this.options,
  });

  factory MerchantField.fromJson(Map<String, dynamic> json) {
    return MerchantField(
      label: json['label'] as String? ?? '',
      paramOrder: json['paramOrder'] as int? ?? 0,
      maxLength: json['maxLength'] as int? ?? 0,
      regex: json['regex'] as String? ?? '',
      inputType: json['inputtype'] as String? ?? '',
      required: json['required'] as String? ?? 'N',
      placeHolder: json['placeHolder'] as String? ?? '',
      unicodeLabel: json['unicodeLabel'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((option) => FieldOption.fromJson(option as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'paramOrder': paramOrder,
      'maxLength': maxLength,
      'regex': regex,
      'inputtype': inputType,
      'required': required,
      'placeHolder': placeHolder,
      'unicodeLabel': unicodeLabel,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
  String get isinputType => inputType.toString().toUpperCase();
  bool get isRequired => required.toUpperCase() == 'Y';
  bool get hasOptions => options.isNotEmpty;
}