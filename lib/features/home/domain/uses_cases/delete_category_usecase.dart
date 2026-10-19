import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/repositories/category_repository.dart';

import '../../../../errors/failures.dart';

class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteCategory(id);
  }
}