import 'package:e_comm/constants.dart';
import 'package:e_comm/screens/register_page.dart';
import 'package:e_comm/widgets/custom_btn.dart';
import 'package:e_comm/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {


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

  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
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
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginAccountFeedBack = await _loginAccount();

    //if the string is not null, we got error while create account
    if(_loginAccountFeedBack != null) {
      _alertDialogBuilder(_loginAccountFeedBack);

      // Set the form to regular state[not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }


//default form loading state
  bool _loginFormLoading = false;

// Form input field values
  String _loginEmail = "";
  String _loginPassword = "";

//Focus Node for inout fields
  FocusNode _passwordFocusNode;




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
             "Welcome User, \n Login to your account",
             textAlign: TextAlign.center,
             style: Constants.boldheading,
             ),
         ),
          Column(
            children: [
              CustomInput(
                hintText: "Email...",
                onChanged: (value) {
                  _loginEmail = value;
                },
                textInputAction: TextInputAction.next,
              ),
              CustomInput(
                hintText: "Password...",
                onChanged: (value) {
                  _loginPassword = value;
                },
                focusNode: _passwordFocusNode,
                isPasswordField: true,
                onSubmitted: (value) {
                  _submitForm();
                },
              ),
              CustomBtn(
                text: "Login",
                onPressed: () {
                  _submitForm();
                },
                isLoading: _loginFormLoading,
                outlineBtn: false
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
            ),
            child: CustomBtn(
              text: "create a New Account",
              onPressed: () {
                print("Clicked the Create Account Button");
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => RegisterPage()
                  ),
                );
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