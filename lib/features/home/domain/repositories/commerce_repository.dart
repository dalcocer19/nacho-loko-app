import 'package:fpdart/fpdart.dart';

import '../../../../errors/failures.dart';
import '../entities/commerce.dart';

abstract class CommerceRepository {
  Future<Either<Failure, Commerce>> getCommerceById(String commerceId);
  Future<Either<Failure, List<Commerce>>> getCommerces();
}