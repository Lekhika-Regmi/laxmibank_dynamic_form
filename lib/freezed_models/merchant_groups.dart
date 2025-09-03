import 'merchant.dart';

class MerchantGroup {
  final String name;
  final String code;
  final String icon;
  final bool tint;
  final bool hasChildren;
  final String description;
  final List<Merchant> merchants;
  final String unicodeName;
  final String unicodeDescription;


  MerchantGroup({
    required this.name,
    required this.code,
    required this.icon,
    required this.tint,
    required this.hasChildren,
    required this.description,
    required this.merchants,
    required this.unicodeName,
    required this.unicodeDescription,

  });

  factory MerchantGroup.fromJson(Map<String, dynamic> json) {
    return MerchantGroup(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      tint: json['tint'] as bool? ?? false,
      hasChildren: json['hasChildren'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      merchants: (json['merchants'] as List<dynamic>?)
          ?.map((merchant) => Merchant.fromJson(merchant as Map<String, dynamic>))
          .toList() ?? [],
      unicodeName: json['unicodeName'] as String? ?? '',
      unicodeDescription: json['unicodeDescription'] as String? ?? '',
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'icon': icon,
      'tint': tint,
      'hasChildren': hasChildren,
      'description': description,
      'merchants': merchants.map((merchant) => merchant.toJson()).toList(),
      'unicodeName': unicodeName,
      'unicodeDescription': unicodeDescription,
    
    };
  }

  // Helper getters
  List<Merchant> get visibleMerchants => merchants.where((m) => m.visible).toList();
  int get merchantCount => merchants.length;
  bool get isEmpty => merchants.isEmpty;
}