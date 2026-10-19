import 'package:flutter_riverpod/legacy.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/get_product_by_id.dart';

import '../../../../core/injection_container.dart';
import '../../domain/entities/product.dart';
import '../../domain/uses_cases/create_product.dart';
import '../../domain/uses_cases/delete_product_usecase.dart';
import '../../domain/uses_cases/get_products_by_category.dart';
import '../../domain/uses_cases/update_product_usecase.dart';
import '../states/product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsByCategory getProductsByCategory;
  final CreateProduct createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final GetProductById getProductById;
  final DeleteProductUsecase deleteProductUsecase;

  ProductNotifier({
    required this.getProductsByCategory,
    required this.createProductUsecase,
    required this.updateProductUsecase,
    required this.getProductById,
    required this.deleteProductUsecase
  })
      : super(const ProductState());

  Future<void> loadProductsByCategory(String categoryId) async {
    // 1. Emitir estado de carga
    state = state.copyWith(isLoading: true, errorMessage: null);

    // 2. Ejecutar el caso de uso
    final result = await getProductsByCategory(categoryId);

    // 3. Desempaquetar el Either
    result.fold(
      // Lado Izquierdo (Failure)
          (failure) {
            print('failure provider $failure');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      // Lado Derecho (Lista de productos)
          (products) {
            print('provider');
            print(products);
        state = state.copyWith(
          isLoading: false,
          products: products,
        );
      },
    );
  }

  Future<void> createProduct(Product product) async {
    // 1. Emitir estado de carga
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await createProductUsecase(product);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(
          isLoading: false,
        );
      },
    );
  }

  Future<void> updateProduct(Product product, {String? imagePath}) async {
    // 1. Emitir estado de carga
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    final result = await updateProductUsecase(product, imagePath: imagePath);
    result.fold(
      (failure) {
        print('failure provider $failure');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(
          product: product,
          isLoading: false,
          isSuccess: true
        );
      },
    );

  }

  Future<void> loadProductById(String id) async {
    // 1. Emitir estado de carga
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getProductById(id);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(
          isLoading: false,
          product: product,
        );
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    // 1. Emitir estado de carga
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await sl<DeleteProductUsecase>().call(productId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
        );
      },
    );
  }
}

// Provider global expuesto para la UI
final productProvider =
StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(
    getProductsByCategory: sl<GetProductsByCategory>(),
    createProductUsecase: sl<CreateProduct>(),
    updateProductUsecase: sl<UpdateProductUsecase>(),
    getProductById: sl<GetProductById>(),
    deleteProductUsecase: sl<DeleteProductUsecase>(),
  );
});