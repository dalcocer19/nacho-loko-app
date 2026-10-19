import 'package:fpdart/fpdart.dart';

import '../../../../errors/exceptions.dart';
import '../../../../errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/category_remote_datasource.dart';
import '../model/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource remoteDatasource;

  CategoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final models = await remoteDatasource.getCategories();
      // Retorno exitoso
      return Right(models);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    try {
      final model = await remoteDatasource.getCategoryById(id);
      // Retorno exitoso
      return Right(model);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel(
        commerceId: category.commerceId,
        name: category.name,
        description: category.description,
      );
      await remoteDatasource.createCategory(model);
      // Retorno exitoso
      return const Right(null);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel(
        id: category.id,
        commerceId: category.commerceId,
        name: category.name,
        description: category.description,
      );
      await remoteDatasource.updateCategory(model);
      // Retorno exitoso
      return const Right(null);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await remoteDatasource.deleteCategory(id);
      // Retorno exitoso
      return const Right(null);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}