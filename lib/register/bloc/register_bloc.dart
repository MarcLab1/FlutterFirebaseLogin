import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/firebase_error_codes.dart';

part 'register_event.dart';
part 'register_state.dart';

//2
final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<InitialEvent>(initialEvent);
    on<RegisterButtonClickedEvent>(registerButtonClickedEvent);
    on<LoginButtonClickedNavigationEvent>(loginButtonClickedNavigationEvent);
  }

  FutureOr<void> registerButtonClickedEvent(
      RegisterButtonClickedEvent event, Emitter<RegisterState> emit) async {
    if (event.password1 != event.password2) {
      emit(RegisterInvalidError(error: "Passwords do not match"));
    } else if (event.password1.length < 6) {
      emit(RegisterInvalidError(
          error: "Password has to be at least 6 characters"));
    } else {
      try {
        final UserCredential userCredential =
            (await _auth.createUserWithEmailAndPassword(
                email: event.email, password: event.password1));
        if (userCredential.user != null) {
          emit(RegisterNavigateToLoggedInPageActionState(
              email: event.email,
              password1: event.password1,
              password2: event.password2));
        }
      } catch (e) {
        // print(e.toString());
        emit(RegisterInvalidError(
            error: FirebaseErrorCodes.getMessageFromErrorCode(
                (e as FirebaseAuthException))));
      }
    }
  }

  FutureOr<void> initialEvent(
      InitialEvent event, Emitter<RegisterState> emit) async {
    //await Future.delayed(Duration(seconds: 2));
    emit(RegisterLoaded());
  }

  FutureOr<void> removeNavigationEvent(
      RemoveNavigationEvent event, Emitter<RegisterState> emit) {
    emit(RegisterLoaded());
  }

  FutureOr<void> loginButtonClickedNavigationEvent(
      LoginButtonClickedNavigationEvent event, Emitter<RegisterState> emit) {
    emit(RegisterNavigateToLoginPageActionState());
  }
}
