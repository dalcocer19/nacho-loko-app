import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/repositories/category_repository.dart';

import '../../../../errors/failures.dart';
import '../entities/category_entity.dart';

class GetCategoriesUsecase {
  final CategoryRepository repository;

  GetCategoriesUsecase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repository.getCategories();
  }
}