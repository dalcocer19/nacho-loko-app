class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final int categoryId;
  final bool isAvailable;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    required this.isAvailable,
  });

}