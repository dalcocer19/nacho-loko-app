import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);
  Future<Either<Failure, Product>> getProductById(String productId);
  Future<Either<Failure, void>> createProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product, {String? imagePath});
  Future<Either<Failure, void>> deleteProduct(String productId);
}