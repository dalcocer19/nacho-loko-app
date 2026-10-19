class Commerce {
  final int? id;
  final String? name;
  final String? description;
  final String? phone;
  final String? logoUrl;

  Commerce({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.logoUrl,
  });

  bool get isNew => id == null;
}