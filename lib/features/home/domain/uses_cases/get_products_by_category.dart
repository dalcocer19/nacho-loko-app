import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  // El método 'call' permite invocar la clase como si fuera una función
  Future<Either<Failure, List<Product>>> call(String categoryId) async {
    // Aquí puedes agregar reglas de negocio específicas si las hubiera
    // (por ejemplo, filtrar productos no disponibles antes de retornar)
    return await repository.getProductsByCategory(categoryId);
  }
}