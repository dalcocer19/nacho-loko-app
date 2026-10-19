import 'package:nacho_loko/features/home/data/datasource/category_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../errors/exceptions.dart';
import '../model/category_model.dart';

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final SupabaseClient supabaseClient;

  CategoryRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await supabaseClient.from('categories').select();
      print('Respuesta de Supabase: $response');
      return (response as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      print('Error al obtener categorías: $e');
      // Error propio devuelto por Supabase/PostgreSQL
      throw ServerException(e.message);
    } catch (e) {
      print('Error inesperado: $e');
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        throw const ServerException('No se encontró ninguna categoría con el ID proporcionado.');
      }

      return CategoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }

  @override
  Future<void> createCategory(CategoryModel category) async {
    try {
      await supabaseClient.from('categories').insert(category.toJson());
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await supabaseClient.from('categories').update(category.toJson()).eq('id', category.id!);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      await supabaseClient.from('categories').delete().eq('id', categoryId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }
}