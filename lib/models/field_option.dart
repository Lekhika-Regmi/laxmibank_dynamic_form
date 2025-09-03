class FieldOption {
  final String label;
  final String value;
  final String? icon;

  FieldOption({
    required this.label,
    required this.value,
    this.icon,
  });

  factory FieldOption.fromJson(Map<String, dynamic> json) {
    return FieldOption(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'icon': icon,
    };
  }

  @override
  String toString() => label;
}
