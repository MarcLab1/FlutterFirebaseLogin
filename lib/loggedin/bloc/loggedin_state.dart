part of 'loggedin_bloc.dart';

@immutable
abstract class LoggedinState {}

class LoggedinInitial extends LoggedinState {}

abstract class LoggedinActionState extends LoggedinState {}

class LoggedinLoaded extends LoggedinState {}

class LoggedinNavigateToForgotPasswordPageActionState
    extends LoggedinActionState {}

class LoggedinNavigateToLoginPageActionState extends LoggedinActionState {}
