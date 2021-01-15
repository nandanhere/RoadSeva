import 'dart:io';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitData;
  final bool isLoading;
  const AuthForm({Key key, this.submitData, this.isLoading}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    print("trying" + isValid.toString());

    if (!_isLogin) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            "Please select user Image",
          ),
        ),
      );
    }
    if ((isValid && !_isLogin) || (_isLogin && isValid)) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();

      widget.submitData(
        _userEmail.trim(),
        _userPassword,
        _userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode _user = new FocusNode();
    FocusNode _password = new FocusNode();

    TextEditingController _email = new TextEditingController();

    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _email,
                    key: ValueKey("Email"),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "Enter Valid Email";
                      }
                      return null;
                    },
                    onFieldSubmitted: (str) {
                      FocusScope.of(context)
                          .requestFocus(_isLogin ? _password : _user);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (_isLogin == false)
                    TextFormField(
                      focusNode: _user,
                      key: ValueKey("UserName"),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "UserName",
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                      onFieldSubmitted: (str) {
                        FocusScope.of(context).requestFocus(_password);
                      },
                    ),
                  TextFormField(
                    focusNode: _password,
                    key: ValueKey("Password"),
                    validator: (value) {
                      if (value.length < 1) {
                        return "Password must be longer";
                      }
                      return null;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    onFieldSubmitted: (str) {
                      _trySubmit();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!widget.isLoading) ...[
                    RaisedButton(
                      onPressed: () => _trySubmit(),
                      child: Text(_isLogin ? "Log in " : "Sign Up!"),
                    ),
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? "Create New Account"
                            : "Have an account ? Log in "))
                  ],
                  if (widget.isLoading)
                    Center(child: CircularProgressIndicator())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
