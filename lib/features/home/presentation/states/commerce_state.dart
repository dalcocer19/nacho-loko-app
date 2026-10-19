import '../../domain/entities/commerce.dart';

class CommerceState {
  final bool isLoading;
  final Commerce? commerce;
  final List<Commerce> commerces;
  final String? errorMessage;

  const CommerceState({
    this.isLoading = false,
    this.commerce,
    this.commerces = const [],
    this.errorMessage,
  });

  // Método copyWith para mantener la inmutabilidad
  CommerceState copyWith({
    bool? isLoading,
    Commerce? commerce,
    List<Commerce>? commerces,
    String? errorMessage,
  }) {
    return CommerceState(
      isLoading: isLoading ?? this.isLoading,
      commerce: commerce ?? this.commerce,
      commerces: commerces ?? this.commerces,
      errorMessage: errorMessage, // Si es nulo, limpia el error anterior
    );
  }
}