import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_bloc.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final RegisterBloc registerBloc = RegisterBloc();

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _password1controller = TextEditingController();
  TextEditingController _password2controller = TextEditingController();

  @override
  void initState() {
    registerBloc.add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        /*WillPopScope(
        onWillPop: () {
          BlocProvider.of<RegisterBloc>(context)
              .add(LoginButtonClickedNavigationEvent());
          return Future(() => true);
        },
        child: 
        
        */
        BlocConsumer<RegisterBloc, RegisterState>(
            bloc: registerBloc,
            listenWhen: (prev, cur) => cur is RegisterActionState,
            buildWhen: (prev, cur) => cur is! RegisterActionState,
            listener: (context, state) {
              if (state is RegisterNavigateToLoginPageActionState) {
                Navigator.of(context).popUntil((route) => route.isFirst);

                _emailcontroller.clear();
                _password1controller.clear();
                _password2controller.clear();
                //registerBloc.add(RemoveNavigationEvent());
              }
              if (state is RegisterNavigateToLoggedInPageActionState) {
                Navigator.of(context).pushNamed('/loggedin', arguments: [
                  state.email,
                  state.password1,
                  state.password2
                ]).then((value) {
                  _emailcontroller.clear();
                  _password1controller.clear();
                  _password2controller.clear();
                  //registerBloc.add(RemoveNavigationEvent());
                });
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case RegisterInitial:
                  {
                    return const Center(
                        heightFactor: 50,
                        widthFactor: 50,
                        child: CircularProgressIndicator());
                  }
                case RegisterLoaded:
                  {
                    return RegisterScaffoldWidget(
                      emailcontroller: _emailcontroller,
                      password1controller: _password1controller,
                      password2controller: _password2controller,
                      registerBloc: registerBloc,
                      error: "",
                    );
                  }
                case RegisterInvalidError:
                  {
                    return RegisterScaffoldWidget(
                      emailcontroller: _emailcontroller,
                      password1controller: _password1controller,
                      password2controller: _password2controller,
                      registerBloc: registerBloc,
                      error: (state as RegisterInvalidError).error,
                    );
                  }
                default:
                  return Container();
              }
            });
  }
}

class RegisterScaffoldWidget extends StatelessWidget {
  const RegisterScaffoldWidget({
    super.key,
    required String error,
    required TextEditingController emailcontroller,
    required TextEditingController password1controller,
    required TextEditingController password2controller,
    required this.registerBloc,
  })  : this.error = error,
        _emailcontroller = emailcontroller,
        _password1controller = password1controller,
        _password2controller = password2controller;

  final TextEditingController _emailcontroller;
  final TextEditingController _password1controller;
  final TextEditingController _password2controller;
  final String error;

  final RegisterBloc registerBloc;

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
                    ),
                    maxLines: 1,
                  )),
              SizedBox(
                  width: 250,
                  child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _password1controller,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    maxLines: 1,
                  )),
              SizedBox(
                  width: 250,
                  child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _password2controller,
                    decoration: InputDecoration(
                      hintText: 'Repeat password',
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
                          registerBloc.add(RegisterButtonClickedEvent(
                            email: _emailcontroller.text,
                            password1: _password1controller.text,
                            password2: _password2controller.text,
                          ));
                        },
                        child: Text("Register")),
                    TextButton(
                      onPressed: () {
                        registerBloc.add(LoginButtonClickedNavigationEvent());
                      },
                      child: Text("Back to login page"),
                    ),
                    Container(
                      width: 10,
                    ),
                  ]),
              Container(
                height: 30,
              ),
              //Text(FirebaseAuth.instance.currentUser?.email.toString() ?? "??")
            ]),
      ),
    );
  }
}
