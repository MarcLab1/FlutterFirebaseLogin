import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/login/bloc/login_bloc.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final LoginBloc loginBloc = LoginBloc();

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  void initState() {
    loginBloc.add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listenWhen: (prev, cur) => cur is LoginActionState,
        buildWhen: (prev, cur) => cur is! LoginActionState,
        listener: (context, state) {
          if (state is LoginNavigateToRegisterPageActionState) {
            Navigator.of(context).pushNamed('/register').then((value) {
              _emailcontroller.clear();
              _passwordcontroller.clear();
              loginBloc.add(RemoveNavigationEvent());
            });
          }
          if (state is LoginNavigateToLoggedInPageActionState) {
            Navigator.of(context).pushNamed('/loggedin',
                arguments: [state.email, state.password]).then((value) {
              _emailcontroller.clear();
              _passwordcontroller.clear();
              loginBloc.add(RemoveNavigationEvent());
            });
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoginInitial:
              {
                return const Center(
                    heightFactor: 50,
                    widthFactor: 50,
                    child: CircularProgressIndicator());
              }
            case LoginLoaded:
              {
                return HomeScaffoldWidget(
                    emailcontroller: _emailcontroller,
                    passwordcontroller: _passwordcontroller,
                    loginBloc: loginBloc,
                    error: "");
                // emailError: false,
                // passwordError: false);
              }
            case LoginInvalidError:
              {
                return HomeScaffoldWidget(
                  emailcontroller: _emailcontroller,
                  passwordcontroller: _passwordcontroller,
                  loginBloc: loginBloc,
                  error: (state as LoginInvalidError).error,
                );
                //emailError: false,
                //passwordError: false,
              }
            default:
              return Container();
          }
        });
  }
}

class HomeScaffoldWidget extends StatelessWidget {
  const HomeScaffoldWidget({
    super.key,
    //required bool emailError,
    //required bool passwordError,
    required String error,
    required TextEditingController emailcontroller,
    required TextEditingController passwordcontroller,
    required this.loginBloc,
  })  : //this.emailError = emailError,
        //this.passwordError = passwordError,
        this.error = error,
        _emailcontroller = emailcontroller,
        _passwordcontroller = passwordcontroller;

  final TextEditingController _emailcontroller;
  final TextEditingController _passwordcontroller;
  //final bool emailError;
  // final bool passwordError;
  final String error;
  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/flutter1.png'),
                width: 50.0,
                height: 70.0,
              ),
              SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      //errorText: emailError ? 'Email has to be @gmail' : null,
                    ),
                    maxLines: 1,
                  )),
              SizedBox(
                  width: 250,
                  child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _passwordcontroller,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      //errorText: passwordError ? 'Password is incorrect' : null,
                    ),
                    maxLines: 1,
                  )),
              (error.isNotEmpty)
                  ? Text(error, style: TextStyle(color: Colors.red))
                  : Text(""),
              Container(
                height: 30,
              ),
              Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  direction: Axis.horizontal,
                  children: [
                    TextButton(
                      onPressed: () {
                        loginBloc.add(LoginButtonClickedEvent(
                            email: _emailcontroller.text,
                            password: _passwordcontroller.text));
                      },
                      child: Text("Login"),
                    ),
                    Container(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          loginBloc.add(RegisterButtonClickedNavigationEvent());
                        },
                        child: Text("Register a new account instead")),
                  ]),
            ]),
      ),
    );
  }
}
