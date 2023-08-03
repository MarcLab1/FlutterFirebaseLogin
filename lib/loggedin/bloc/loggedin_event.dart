part of 'loggedin_bloc.dart';

@immutable
abstract class LoggedinEvent {}

class InitialEvent extends LoggedinEvent {}

class LogoutButtonClickedNavigationEvent extends LoggedinEvent {}

class RemoveNavigationEvent extends LoggedinEvent {}
