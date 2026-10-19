import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<Either<Failure, Product>> call(String productId) async {
    return await repository.getProductById(productId);
  }
}