import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/repositories/product_repository.dart';

import '../../../../errors/failures.dart';
import '../entities/product.dart';

class UpdateProductUsecase {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  Future<Either<Failure, Product>> call(Product product, {String? imagePath}) async {
    return await repository.updateProduct(product, imagePath: imagePath);
  }
}