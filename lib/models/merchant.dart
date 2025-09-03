import 'merchant_field.dart';

class Merchant {
  final int id;
  final String name;
  final String description;
  final String code;
  final String merchantTypeCode;
  final String icon;
  final bool visible;
  final bool tint;
  final String payableLimitType;
  final List<MerchantField> fields;
  final List<dynamic> payableLimit; // Keep as dynamic
  final String featureCode;
  final String unicodeName;
  final String unicodeDescription;
  final String offerText;
  final String instruction;

  Merchant({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.merchantTypeCode,
    required this.icon,
    required this.visible,
    required this.tint,
    required this.payableLimitType,
    required this.fields,
    required this.payableLimit,
    required this.featureCode,
    required this.unicodeName,
    required this.unicodeDescription,
    required this.offerText,
    required this.instruction,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      code: json['code'] as String? ?? '',
      merchantTypeCode: json['merchantTypeCode'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      visible: json['visible'] as bool? ?? false,
      tint: json['tint'] as bool? ?? false,
      payableLimitType: json['payableLimitType'] as String? ?? '',
      fields:
          (json['fields'] as List<dynamic>?)
              ?.map(
                (field) =>
                    MerchantField.fromJson(field as Map<String, dynamic>),
              )
              .toList() ??
          [],
      payableLimit: json['payableLimit'] as List<dynamic>? ?? [],
      featureCode: json['featureCode'] as String? ?? '',
      unicodeName: json['unicodeName'] as String? ?? '',
      unicodeDescription: json['unicodeDescription'] as String? ?? '',
      offerText: json['offerText'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'merchantTypeCode': merchantTypeCode,
      'icon': icon,
      'visible': visible,
      'tint': tint,
      'payableLimitType': payableLimitType,
      'fields': fields.map((field) => field.toJson()).toList(),
      'payableLimit': payableLimit,
      'featureCode': featureCode,
      'unicodeName': unicodeName,
      'unicodeDescription': unicodeDescription,
      'offerText': offerText,
      'instruction': instruction,
    };
  }

  // Helper getters
  bool get hasFixedAmounts => payableLimitType == 'F';
  bool get hasRangeAmounts => payableLimitType == 'R';

  List<double> get fixedAmounts {
    return payableLimit
        .where(
          (limit) => limit is Map<String, dynamic> && _isFixedAmount(limit),
        )
        .map((limit) => _getFixedAmount(limit as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic>? get rangeLimit {
    if (hasRangeAmounts &&
        payableLimit.isNotEmpty &&
        payableLimit.first is Map<String, dynamic>) {
      return payableLimit.first as Map<String, dynamic>;
    }
    return null;
  }

  List<MerchantField> get sortedFields =>
      fields..sort((a, b) => a.paramOrder.compareTo(b.paramOrder));

  // Helper methods to work with payableLimit
  bool _isFixedAmount(Map<String, dynamic> limit) {
    // Adjust this logic based on your actual data structure
    return limit['type'] == 'fixed' || limit.containsKey('fixedAmount');
  }

  double _getFixedAmount(Map<String, dynamic> limit) {
    // Adjust this based on your actual data structure
    return (limit['fixedAmount'] as num?)?.toDouble() ?? 0.0;
  }
}
