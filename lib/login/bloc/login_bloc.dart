import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../core/firebase_error_codes.dart';

part 'login_event.dart';
part 'login_state.dart';

//2
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<InitialEvent>(initialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<RegisterButtonClickedNavigationEvent>(
        registerButtonClickedNavigationEvent);
    on<RemoveNavigationEvent>(removeNavigationEvent);
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginState> emit) async {
    try {
      print("clicked");

      final UserCredential userCredential =
          (await _auth.signInWithEmailAndPassword(
              email: event.email, password: event.password));

      if (userCredential.user != null) {
        emit(LoginNavigateToLoggedInPageActionState(
            email: event.email, password: event.password));
      }
    } catch (e) {
      print(e.toString());
      emit(LoginInvalidError(
          error: FirebaseErrorCodes.getMessageFromErrorCode(
              (e as FirebaseAuthException))));
    }
  }

  FutureOr<void> initialEvent(
      InitialEvent event, Emitter<LoginState> emit) async {
    await Future.delayed(Duration(seconds: 2));
    emit(LoginLoaded());
  }

  FutureOr<void> removeNavigationEvent(
      RemoveNavigationEvent event, Emitter<LoginState> emit) {
    emit(LoginLoaded());
  }

  FutureOr<void> registerButtonClickedNavigationEvent(
      RegisterButtonClickedNavigationEvent event,
      Emitter<LoginState> emit) async {
    //await _auth.signOut();
    //emit(LoginLoaded());
    emit(LoginNavigateToRegisterPageActionState());
  }
}
