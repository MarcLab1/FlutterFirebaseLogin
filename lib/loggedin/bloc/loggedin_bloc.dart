import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'loggedin_event.dart';
part 'loggedin_state.dart';

//2
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoggedinBloc extends Bloc<LoggedinEvent, LoggedinState> {
  LoggedinBloc() : super(LoggedinInitial()) {
    on<InitialEvent>(initialEvent);
    on<LoggedinEvent>((event, emit) {});
    on<LogoutButtonClickedNavigationEvent>(logoutButtonClickedNavigationEvent);
    on<RemoveNavigationEvent>(removeNavigationEvent);
  }
  FutureOr<void> initialEvent(
      InitialEvent event, Emitter<LoggedinState> emit) async {
    await Future.delayed(Duration(seconds: 1));
    emit(LoggedinLoaded());
  }

  FutureOr<void> removeNavigationEvent(
      RemoveNavigationEvent event, Emitter<LoggedinState> emit) {
    emit(LoggedinLoaded());
  }

  FutureOr<void> logoutButtonClickedNavigationEvent(
      LogoutButtonClickedNavigationEvent event,
      Emitter<LoggedinState> emit) async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => emit(LoggedinNavigateToLoginPageActionState()));
  }
}
