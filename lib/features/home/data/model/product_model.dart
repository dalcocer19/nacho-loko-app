import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required super.categoryId,
    required super.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
      isAvailable: json['is_available'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['image_url'] = imageUrl;
    data['category_id'] = categoryId;
    data['is_available'] = isAvailable;
    return data;
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? categoryId,
    bool? isAvailable,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}