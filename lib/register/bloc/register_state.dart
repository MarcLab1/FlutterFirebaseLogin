part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

abstract class RegisterActionState extends RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoaded extends RegisterState {}

class RegisterInvalidCredentialsError extends RegisterState {}

class RegisterInvalidError extends RegisterState {
  final String error;
  RegisterInvalidError({required this.error});
}

class RegisterNavigateToLoginPageActionState extends RegisterActionState {}

class RegisterNavigateToLoggedInPageActionState extends RegisterActionState {
  final String email;
  final String password1;
  final String password2;

  RegisterNavigateToLoggedInPageActionState(
      {required this.email, required this.password1, required this.password2});
}
