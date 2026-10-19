import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/commerce.dart';
import '../repositories/commerce_repository.dart';

class GetCommercesUseCase {
  final CommerceRepository repository;
  GetCommercesUseCase(this.repository);

  Future<Either<Failure, List<Commerce>>> call() {
    return repository.getCommerces();
  }
}