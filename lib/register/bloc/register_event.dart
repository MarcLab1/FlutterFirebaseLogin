part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class InitialEvent extends RegisterEvent {}

class RegisterButtonClickedEvent extends RegisterEvent {
  final String email;
  final String password1;
  final String password2;
  RegisterButtonClickedEvent(
      {required this.email, required this.password1, required this.password2});
}

class LoginButtonClickedNavigationEvent extends RegisterEvent {}

class RemoveNavigationEvent extends RegisterEvent {}
