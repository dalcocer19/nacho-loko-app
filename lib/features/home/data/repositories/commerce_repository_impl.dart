import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/entities/commerce.dart';

import '../../../../errors/exceptions.dart';
import '../../../../errors/failures.dart';
import '../../domain/repositories/commerce_repository.dart';
import '../datasource/commerce_remote_datasource.dart';

class CommerceRepositoryImpl implements CommerceRepository {
  final CommerceRemoteDatasource remoteDatasource;

  CommerceRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, Commerce>> getCommerceById(String commerceId) async {
    try {
      final model = await remoteDatasource.getCommerceById(commerceId);
      // Retorno exitoso
      return Right(model);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      print("Server Exception${e.message}");
      return Left(ServerFailure(e.message));
    } catch (e) {
      print("UnknownFailure Exception${e.toString()}");
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<Commerce>>> getCommerces() async {
    try {
      final models = await remoteDatasource.getCommerces();
      // Retorno exitoso
      return Right(models);
    } on ServerException catch (e) {
      // Retorno de fallo por servidor
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}