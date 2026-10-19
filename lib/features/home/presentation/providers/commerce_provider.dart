import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/injection_container.dart';
import '../../domain/uses_cases/get_commerce_usecase.dart';
import '../../domain/uses_cases/get_commerces_usecase.dart';
import '../states/commerce_state.dart';

class CommerceNotifier extends StateNotifier<CommerceState> {
  final GetCommercesUseCase getCommercesUseCase;
  final GetCommerceUseCase getCommerceUseCase;

  CommerceNotifier({
    required this.getCommercesUseCase,
    required this.getCommerceUseCase,
  }) : super(const CommerceState());

  Future<void> loadCommerces() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getCommercesUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (commerces) {
        state = state.copyWith(
          isLoading: false,
          commerces: commerces,
        );
      },
    );
  }

  Future<void> loadCommerce(String commerceId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getCommerceUseCase(commerceId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (commerce) {
        state = state.copyWith(
          isLoading: false,
          commerce: commerce,
        );
      },
    );
  }
}

final commerceProvider = StateNotifierProvider<CommerceNotifier, CommerceState>((ref) {
  return CommerceNotifier(
    getCommercesUseCase: sl<GetCommercesUseCase>(),
    getCommerceUseCase: sl<GetCommerceUseCase>(),
  );
});