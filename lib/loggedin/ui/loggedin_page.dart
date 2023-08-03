import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/loggedin/bloc/loggedin_bloc.dart';

class LoggedinWidget extends StatefulWidget {
  const LoggedinWidget({super.key});

  @override
  State<LoggedinWidget> createState() => _LoggedinWidgetState();
}

class _LoggedinWidgetState extends State<LoggedinWidget> {
  final LoggedinBloc loggedinBloc = LoggedinBloc();

  @override
  void initState() {
    loggedinBloc.add(InitialEvent());
    super.initState();
  }

  //overriding the back button
  Future<bool> _logoutClicked() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Going back will log you out'),
                        Text('Are you sure you want to logout?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Yes, Im sure'),
                      onPressed: () {
                        /*
                        FirebaseAuth.instance.signOut().then((value) =>
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst));
                                */
                        loggedinBloc.add(LogoutButtonClickedNavigationEvent());
                      },
                    ),
                    TextButton(
                      child: const Text('No, cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context)?.settings.arguments;
    if (map is List<String>) {
      var list = map as List<String>;

      return WillPopScope(
          onWillPop: _logoutClicked,
          child: BlocConsumer<LoggedinBloc, LoggedinState>(
              bloc: loggedinBloc,
              listenWhen: (prev, cur) => cur is LoggedinActionState,
              buildWhen: (prev, cur) => cur is! LoggedinActionState,
              listener: (context, state) {
                if (state is LoggedinNavigateToLoginPageActionState) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case LoggedinInitial:
                    {
                      return const Center(
                          heightFactor: 50,
                          widthFactor: 50,
                          child: CircularProgressIndicator());
                    }
                  case LoggedinLoaded:
                    {
                      return Scaffold(
                        body: SingleChildScrollView(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 50),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage('assets/flutter1.png'),
                                  width: 50.0,
                                  height: 70.0,
                                ),
                                Container(
                                  height: 30,
                                ),
                                Text('Logged in as ${list[0]}'),
                                Text(
                                    'Password is ${list[1]} but I didn\'t tell you this :)'),
                                TextButton(
                                  onPressed: _logoutClicked,
                                  child: Text("Logout"),
                                ),
                                Container(
                                  height: 30,
                                ),
                                Text(FirebaseAuth.instance.currentUser?.email
                                        .toString() ??
                                    "??")
                              ]),
                        ),
                      );
                    }
                  default:
                    return Container();
                }
              }));
    } else
      return Container();
  }
}
