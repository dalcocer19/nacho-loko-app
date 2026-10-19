import 'package:fpdart/fpdart.dart';
import 'package:nacho_loko/features/home/domain/repositories/commerce_repository.dart';

import '../../../../errors/failures.dart';
import '../entities/commerce.dart';

class GetCommerceUseCase {
  final CommerceRepository repository;
  GetCommerceUseCase(this.repository);

  Future<Either<Failure, Commerce>> call(String commerceId) async {
    return await repository.getCommerceById(commerceId);
  }
}