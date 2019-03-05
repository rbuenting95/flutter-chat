import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'login_bloc.dart';
import 'login_state.dart';
import '../navigation_helper.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: _bloc,
      child: LoginWidget(widget: widget)
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key key, @required this.widget}) : super(key: key);

  final LoginScreen widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: BlocBuilder(
          bloc: BlocProvider.of<LoginBloc>(context),
          builder: (context, LoginState state) {
            if (state.loggedIn) {
              _segueToMain(context);
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                )
              );
            }
            if (state.loading) {
              return Center(
                  child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 256.0,
                      height: 32.0,
                      child: RaisedButton(
                        onPressed: () =>
                            BlocProvider.of<LoginBloc>(context).onLoginGoogle(),
                        child: Text(
                          "Login with Google",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.redAccent,
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 256.0,
                      height: 32.0,
                      child: RaisedButton(
                        onPressed: () => BlocProvider.of<LoginBloc>(context)
                            .onLoginFacebook(),
                        child: Text(
                          "Login with Facebook",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  void _segueToMain(BuildContext context) async {
      await Future.delayed(const Duration(milliseconds: 100));
      NavigationHelper.navigateToMain(context);
  }
}
