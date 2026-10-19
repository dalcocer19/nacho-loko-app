import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryById {
  final CategoryRepository repository;

  GetCategoryById(this.repository);

  Future<Either<Failure, CategoryEntity>> call(String categoryId) async {
    return await repository.getCategoryById(categoryId);
  }
}