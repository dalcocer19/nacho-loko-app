import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../errors/exceptions.dart';
import 'product_remote_datasource.dart';
import '../model/product_model.dart';

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final SupabaseClient supabaseClient;

  ProductRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('category_id', categoryId);

      print(response);
      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      print('Error en product remote datasource impl');
      print(e.message);
      // Error propio devuelto por Supabase/PostgreSQL
      throw ServerException(e.message);
    } catch (e) {
      print('Error en product remote datasource impl $e');
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await supabaseClient
        .from('products')
        .select()
        .eq('id', id)
        .single();

    return ProductModel.fromJson(response);
  }

  /*@override
  Future<void> createProduct(ProductModel product) async {
    try {
      await supabaseClient.from('products').insert(product.toJson());
    } on PostgrestException catch (e) {
      print('Error en product remote datasource impl');
      print(e.message);
      // Error propio devuelto por Supabase/PostgreSQL
      throw ServerException(e.message);
    }
  }*/

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      String? finalImageUrl = product.imageUrl;

      // 1. Si viene una ruta local, subirla primero a Storage para obtener la URL de red
      if (product.imageUrl != null &&
          product.imageUrl!.isNotEmpty &&
          !product.imageUrl!.startsWith('http')) {

        final file = File(product.imageUrl!);
        final fileExtension = product.imageUrl!.split('.').last;

        // Usamos timestamp para garantizar un nombre único en la subida
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        final storagePath = 'products/${timeStamp}_product.$fileExtension';

        // Subir archivo al bucket 'commerce-images'
        await supabaseClient.storage
            .from('commerce-images')
            .upload(
          storagePath,
          file,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$fileExtension',
          ),
        );

        // Obtener la URL pública Web para guardarla en la BD
        finalImageUrl = supabaseClient.storage
            .from('commerce-images')
            .getPublicUrl(storagePath);
      }

      // 2. Asignar la URL pública al modelo
      final productToInsert = product.copyWith(imageUrl: finalImageUrl);

      // 3. INSERTAR el nuevo registro en la base de datos (NO usar update)
      await supabaseClient
          .from('products')
          .insert(productToInsert.toJson());

    } on StorageException catch (e) {
      print('Error al subir la imagen en Supabase Storage: ${e.message}');
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      print('Error al insertar el producto en la BD: ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      print('Error inesperado al crear el producto: $e');
      throw ServerException(e.toString());
    }
  }


  @override
  Future<ProductModel> updateProduct(ProductModel product, {String? imagePath}) async {
    try {
      String? finalImageUrl = product.imageUrl;
      print('entra a updateProduct');
      // 1. Si enviamos una ruta local (de la galería o cámara), la subimos a Supabase Storage
      if (imagePath != null && imagePath.isNotEmpty && !imagePath.startsWith('http')) {
        print('entra al if');
        final file = File(imagePath);
        final fileExtension = imagePath.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${product.id}.$fileExtension';
        final storagePath = 'products/$fileName';

        // Subir archivo al bucket 'product-images'
        await supabaseClient.storage
            .from('commerce-images')
            .upload(
          storagePath,
          file,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$fileExtension',
          ),
        );

        // Obtener la URL pública generada por Supabase
        finalImageUrl = supabaseClient.storage
            .from('commerce-images')
            .getPublicUrl(storagePath);
        print('finalImageUrl: $finalImageUrl');
      } else if (imagePath == null) {
        print('entra al else if');
        // Si la imagen fue eliminada explícitamente en el formulario
        finalImageUrl = null;
      }

      // 2. Crear una nueva instancia del modelo con la URL final de la imagen
      final updatedProduct = product.copyWith(imageUrl: finalImageUrl);
      print('updatedProduct: $updatedProduct');
      // 3. Actualizar la tabla 'products' filtrando por el ID
      await supabaseClient
          .from('products')
          .update(updatedProduct.toJson())
          .eq('id', product.id!);

      print('salio del update');
      return updatedProduct;

    } on StorageException catch (e) {
      print('Error al subir la imagen en Supabase Storage: ${e.message}');
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      print('Error al actualizar la tabla de productos: ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      print('Error inesperado al editar el producto: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await supabaseClient.from('products').delete().eq('id', productId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Error inesperado al conectar con Supabase');
    }
  }


}