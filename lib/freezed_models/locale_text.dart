class LocaleText {
  final String? np;
  final String? en;

  LocaleText({this.np, this.en});

  factory LocaleText.fromJson(Map<String, dynamic> json) {
    return LocaleText(
      np: json['np'] as String?,
      en: json['en'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'np': np,
      'en': en,
    };
  }

  @override
  String toString() {
    return en ?? np ?? '';
  }
}

// ==========================================
// File: lib/models/locale.dart
// ==========================================


class Locale {
  final LocaleText name;
  final LocaleText description;
  final LocaleText? placeHolder;
  final LocaleText? label;

  Locale({
    required this.name,
    required this.description,
    this.placeHolder,
    this.label,
  });

  factory Locale.fromJson(Map<String, dynamic> json) {
    return Locale(
      name: LocaleText.fromJson(json['name'] ?? {}),
      description: LocaleText.fromJson(json['description'] ?? {}),
      placeHolder: json['placeHolder'] != null 
          ? LocaleText.fromJson(json['placeHolder']) 
          : null,
      label: json['label'] != null 
          ? LocaleText.fromJson(json['label']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.toJson(),
      'description': description.toJson(),
      'placeHolder': placeHolder?.toJson(),
      'label': label?.toJson(),
    };
  }
}