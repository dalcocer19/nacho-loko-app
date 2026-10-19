import 'package:flutter_riverpod/legacy.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/create_category_usecase.dart';
import 'package:nacho_loko/features/home/domain/uses_cases/get_categories_usecase.dart';

import '../../../../core/injection_container.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/uses_cases/delete_category_usecase.dart';
import '../../domain/uses_cases/get_category_by_id.dart';
import '../../domain/uses_cases/update_category_usecase.dart';
import '../states/category_state.dart';

class CategoryProvider extends StateNotifier<CategoryState> {
  final CreateCategoryUsecase createCategoryUsecase;
  final GetCategoriesUsecase getCategoriesUsecase;
  final GetCategoryById getCategoriesById;
  final UpdateCategoryUsecase updateCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;

  CategoryProvider({
    required this.createCategoryUsecase,
    required this.getCategoriesUsecase,
    required this.getCategoriesById,
    required this.updateCategoryUsecase,
    required this.deleteCategoryUsecase,
  }) : super(const CategoryState());

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getCategoriesUsecase();

    result.fold(
      (failure) {
        print('Error al cargar categorías: $failure');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (categories) {
        print('Categorías cargadas: $categories');
        state = state.copyWith(
          isLoading: false,
          categories: categories,
        );
      },
    );
  }

  Future<void> loadCategory(String categoryId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getCategoriesById(categoryId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (category) {
        state = state.copyWith(
          isLoading: false,
          category: category,
        );
      },
    );
  }

  Future<void> createCategory(CategoryEntity category) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await createCategoryUsecase(category);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
        );
      },
    );
  }

  Future<void> updateCategory(CategoryEntity category) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await updateCategoryUsecase(category);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        },
      (_) {
        state = state.copyWith(
          isLoading: false,
        );
      },
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await deleteCategoryUsecase(categoryId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        },
      (_) {
        state = state.copyWith(
          isLoading: false,
        );
      },
    );
  }

}

final categoryProvider = StateNotifierProvider<CategoryProvider, CategoryState>((ref) {
  return CategoryProvider(
    createCategoryUsecase: sl<CreateCategoryUsecase>(),
    getCategoriesUsecase: sl<GetCategoriesUsecase>(),
    getCategoriesById: sl<GetCategoryById>(),
    updateCategoryUsecase: sl<UpdateCategoryUsecase>(),
    deleteCategoryUsecase: sl<DeleteCategoryUsecase>(),
  );
});