import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/repositories/category_repository.dart';

import '../../../../errors/failures.dart';
import '../entities/category_entity.dart';

class CreateCategoryUsecase {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);

  Future<Either<Failure, void>> call(CategoryEntity category) async {

    return await repository.createCategory(category);
  }
}