import '../../domain/entities/commerce.dart';

class CommerceModel extends Commerce {
  CommerceModel({
    required super.id,
    required super.name,
    super.description,
    super.phone,
    super.logoUrl,
  });

  factory CommerceModel.fromJson(Map<String, dynamic> json) {
    return CommerceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      logoUrl: json['logo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['phone'] = phone;
    data['logo_url'] = logoUrl;
    return data;

  }
}