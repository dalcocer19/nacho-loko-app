import 'package:nacho_loko/features/home/data/datasource/commerce_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../errors/exceptions.dart';
import '../model/commerce_model.dart';

class CommerceRemoteDatasourceImpl implements CommerceRemoteDatasource {
  final SupabaseClient supabaseClient;

  CommerceRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<CommerceModel>> getCommerces() async {
    try {
      final response = await supabaseClient.from('commerces').select();

      return (response as List)
          .map((json) => CommerceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      // Error propio devuelto por Supabase/PostgreSQL
      throw ServerException(e.message);
    } catch (e) {
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }

  @override
  Future<CommerceModel> getCommerceById(String id) async {
    try {
      final response = await supabaseClient
          .from('commerces')
          .select()
          .eq('id', 1)
          .maybeSingle();

      if (response == null) {
        //throw const ServerException('No se encontró ningún comercio con el ID proporcionado.');
        print('No se encontró ningún comercio con el ID proporcionado.');
      }
      print('Response: $response');

      return CommerceModel.fromJson(response!);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      print('Entro en catch error inesperado al conectar con Supabase: $e');

      if (e is ServerException) rethrow;
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }
}