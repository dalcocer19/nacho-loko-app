import '../model/commerce_model.dart';

abstract class CommerceRemoteDatasource {
  Future<List<CommerceModel>> getCommerces();
  Future<CommerceModel> getCommerceById(String id);
}