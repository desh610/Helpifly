part of 'login_cubit.dart';

class LoginState {
  final bool isLoading;

  LoginState({
    required this.isLoading,
  });

  LoginState copyWith({
    bool? isLoading,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
