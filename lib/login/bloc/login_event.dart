part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class InitialEvent extends LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {
  final String email;
  final String password;
  LoginButtonClickedEvent({required this.email, required this.password});
}

class LogoutButtonClickedEvent extends LoginEvent {}

class RegisterButtonClickedNavigationEvent extends LoginEvent {}

class RemoveNavigationEvent extends LoginEvent {}
