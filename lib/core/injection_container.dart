// lib/core/injection/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/create_product.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/delete_category_usecase.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/get_categories_usecase.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/get_commerce_usecase.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/update_category_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Datasources
import '../features/home/data/datasource/category_remote_datasource.dart';
import '../features/home/data/datasource/category_remote_datasource_impl.dart';
import '../features/home/data/datasource/commerce_remote_datasource.dart';
import '../features/home/data/datasource/commerce_remote_datasource_impl.dart';
import '../features/home/data/datasource/product_remote_datasource.dart';
import '../features/home/data/datasource/product_remote_datasource_impl.dart';
// Repositories
import '../features/home/data/repositories/category_repository_impl.dart';
import '../features/home/data/repositories/commerce_repository_impl.dart';
import '../features/home/data/repositories/product_repository_impl.dart';
import '../features/home/domain/repositories/category_repository.dart';
import '../features/home/domain/repositories/commerce_repository.dart';
import '../features/home/domain/repositories/product_repository.dart';
// Use Cases
import '../features/home/domain/uses_cases/create_category_usecase.dart';
import '../features/home/domain/uses_cases/delete_product_usecase.dart';
import '../features/home/domain/uses_cases/get_category_by_id.dart';
import '../features/home/domain/uses_cases/get_commerces_usecase.dart';
import '../features/home/domain/uses_cases/get_product_by_id.dart';
import '../features/home/domain/uses_cases/get_products_by_category.dart';
import '../features/home/domain/uses_cases/update_product_usecase.dart';



final sl = GetIt.instance; // sl = Service Locator

Future<void> initInjection() async {
  // ---------------------------------------------------------------------------
  // 1. External (Supabase Client)
  // ---------------------------------------------------------------------------
  // Obtenemos la instancia de Supabase inicializada previamente en el main
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ---------------------------------------------------------------------------
  // 2. Datasources
  // ---------------------------------------------------------------------------
  // Se usa LazySingleton porque solo necesitamos una instancia viva del datasource
  sl.registerLazySingleton<ProductRemoteDatasource>(
        () => ProductRemoteDatasourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<CommerceRemoteDatasource>(
      () => CommerceRemoteDatasourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<CategoryRemoteDatasource>(
      () => CategoryRemoteDatasourceImpl(sl<SupabaseClient>()),
  );

  // ---------------------------------------------------------------------------
  // 3. Repositories
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(remoteDatasource: sl<ProductRemoteDatasource>()),
  );
  sl.registerLazySingleton<CommerceRepository>(
        () => CommerceRepositoryImpl(remoteDatasource: sl<CommerceRemoteDatasource>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(remoteDatasource: sl<CategoryRemoteDatasource>()),
  );

  // ---------------------------------------------------------------------------
  // 4. Use Cases
  // ---------------------------------------------------------------------------
  // Se suele usar Factory para crear una nueva instancia cada vez que se invoque
  sl.registerFactory<GetProductsByCategory>(
        () => GetProductsByCategory(sl<ProductRepository>()),
  );
  sl.registerFactory<CreateProduct>(
        () => CreateProduct(sl<ProductRepository>()),
  );
  sl.registerFactory<GetProductById>(
        () => GetProductById(sl<ProductRepository>()),
  );
  sl.registerFactory<UpdateProductUsecase>(
        () => UpdateProductUsecase(sl<ProductRepository>()),
  );
  sl.registerFactory<DeleteProductUsecase>(
        () => DeleteProductUsecase(sl<ProductRepository>()),
  );

  sl.registerFactory<GetCommercesUseCase>(
        () => GetCommercesUseCase(sl<CommerceRepository>()),
  );
  sl.registerFactory<GetCommerceUseCase>(
        () => GetCommerceUseCase(sl<CommerceRepository>()),
  );

  sl.registerFactory<GetCategoriesUsecase>(
      () => GetCategoriesUsecase(sl<CategoryRepository>()),
  );
  sl.registerFactory<GetCategoryById>(
      () => GetCategoryById(sl<CategoryRepository>()),
  );
  sl.registerFactory<CreateCategoryUsecase>(
      () => CreateCategoryUsecase(sl<CategoryRepository>()),
  );
  sl.registerFactory<UpdateCategoryUsecase>(
        () => UpdateCategoryUsecase(sl<CategoryRepository>()),
  );
  sl.registerFactory<DeleteCategoryUsecase>(
        () => DeleteCategoryUsecase(sl<CategoryRepository>()),
  );

}