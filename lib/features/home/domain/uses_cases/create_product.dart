import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Either<Failure, void>> call(Product product) async {
    // Validación o regla de negocio pre-guardado
    if(product.price <= 0) {
      throw Exception('El precio del producto debe ser mayor a cero.');
    }
    return await repository.createProduct(product);
  }
}