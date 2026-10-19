

import 'package:nacho_loko/features/home/domain/entities/product.dart';

import '../../domain/entities/category_entity.dart';

class CategoryState {
  final bool isLoading;
  final CategoryEntity? category;
  final List<CategoryEntity>? categories;
  final List<Product> products;
  final String? errorMessage;

  const CategoryState({
    this.isLoading = false,
    this.category,
    this.categories = const [],
    this.products = const [],
    this.errorMessage,
  });

  // Método copyWith para mantener la inmutabilidad
  CategoryState copyWith({
    bool? isLoading,
    CategoryEntity? category,
    List<CategoryEntity>? categories,
    List<Product>? products,
    String? errorMessage,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      errorMessage: errorMessage, // Si es nulo, limpia el error anterior
    );
  }
}