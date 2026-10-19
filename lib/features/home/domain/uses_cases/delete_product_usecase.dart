import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/repositories/product_repository.dart';

import '../../../../errors/failures.dart';

class DeleteProductUsecase {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);
  
  Future<Either<Failure, void>> call(String productId) {
    return repository.deleteProduct(productId);
  }
}