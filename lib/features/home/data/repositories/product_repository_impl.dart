import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/data/datasource/product_remote_datasource.dart';
import 'package:nacho_loko/features/home/domain/entities/product.dart';

import '../../../../errors/exceptions.dart';
import '../../../../errors/failures.dart';
import '../../domain/repositories/product_repository.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  
  ProductRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, void>> createProduct(Product product) async {
    try {
      final model = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        categoryId: product.categoryId,
        isAvailable: product.isAvailable,
      );
      await remoteDatasource.createProduct(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }

  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product, {String? imagePath}) async {
    try {
      final model = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        categoryId: product.categoryId,
        isAvailable: product.isAvailable,
      );
      final updatedProduct = await remoteDatasource.updateProduct(model, imagePath: imagePath);
      return Right(updatedProduct);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }


  @override
  Future<Either<Failure, Product>> getProductById(String productId) async {
    try {
      final model = await remoteDatasource.getProductById(productId);
      // Retorno exitoso
      return Right(model);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId) async {
    try {
      final models = await remoteDatasource.getProductsByCategory(categoryId);
      // Retorno exitoso
      return Right(models);
    } on ServerException catch (e) {
      print('Error en product repository impl');
      print(e.message);
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await remoteDatasource.deleteProduct(productId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}