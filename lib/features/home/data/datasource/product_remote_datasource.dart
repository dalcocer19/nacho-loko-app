import '../model/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product, {String? imagePath});
  Future<void> deleteProduct(String productId);
}