part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginInvalidError extends LoginState {
  final String error;
  LoginInvalidError({required this.error});
}

class LoginNavigateToRegisterPageActionState extends LoginActionState {}

class LoginNavigateToLoggedInPageActionState extends LoginActionState {
  final String email;
  final String password;
  LoginNavigateToLoggedInPageActionState(
      {required this.email, required this.password});
}
