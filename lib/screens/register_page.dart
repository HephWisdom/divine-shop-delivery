import 'package:e_comm/widgets/custom_btn.dart';
import 'package:e_comm/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {



  //Build an alert dialog to display some errors
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            FlatButton(
              child: Text("close Dialog"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]
        );
      }
    );
  }

  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
      //Set the form to loading state
      setState(() {
        _registerFormLoading = true;
      });

      // Run the create account method
      String _createAccountFeedBack = await _createAccount();

      //if the string is not null, we got error while create account
      if(_createAccountFeedBack != null) {
        _alertDialogBuilder(_createAccountFeedBack);

        // Set the form to regular state[not loading].
        setState(() {
          _registerFormLoading = false;
        });
      } else {
        //the string was null, user is logged in.
        Navigator.pop(context);
      }
  }

  //default form loading state
  bool _registerFormLoading = false;

  // Form input field values
  String _registerEmail = "";
  String _registerPassword = "";

  //Focus Node for inout fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            bottom: true,
            child: Container(
              width:  double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 24.0,
                    ),
                    child: Text(
                      "Create A New Account",
                      textAlign: TextAlign.center,
                      style: Constants.boldheading,
                    ),
                  ),
                  Column(
                    children: [
                      CustomInput(
                        hintText: "Email...",
                        onChanged: (value) {
                          _registerEmail = value;
                        },
                        onSubmitted: (value) {
                          _passwordFocusNode.requestFocus();
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      CustomInput(
                        hintText: "Password...",
                        onChanged: (value) {
                          _registerPassword = value;
                        },

                        focusNode: _passwordFocusNode,
                        isPasswordField: true,
                        onSubmitted: (value) {
                          _submitForm();
                        },
                      ),
                      CustomBtn(
                          text: "Create New account",
                          onPressed: () {
                            _submitForm();
                          },
                          isLoading: _registerFormLoading,
                          outlineBtn: false
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: CustomBtn(
                      text: "Back To Login",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      outlineBtn: true,
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
