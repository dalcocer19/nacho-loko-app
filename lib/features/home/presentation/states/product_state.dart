import '../../domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final bool isSuccess;
  final List<Product> products;
  final Product? product;
  final String? errorMessage;

  const ProductState({
    this.isLoading = false,
    this.isSuccess = false,
    this.product,
    this.products = const [],
    this.errorMessage,
  });

  // Método copyWith para mantener la inmutabilidad
  ProductState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<Product>? products,
    Product? product,
    String? errorMessage,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      products: products ?? this.products,
      product: product ?? this.product,
      errorMessage: errorMessage, // Si es nulo, limpia el error anterior
    );
  }
}