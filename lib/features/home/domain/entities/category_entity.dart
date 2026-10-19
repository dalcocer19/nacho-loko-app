class CategoryEntity {
  final int? id;
  final int commerceId;
  final String name;
  final String description;

  CategoryEntity({
    this.id,
    required this.commerceId,
    required this.name,
    required this.description,
  });
}