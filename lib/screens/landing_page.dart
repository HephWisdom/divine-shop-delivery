
import 'package:e_comm/constants.dart';
import 'package:e_comm/screens/home_page.dart';
import 'package:e_comm/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //if Firebase App init, snapshot has error
        if(snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        //connection initialised = firebase app is running
        if(snapshot.connectionState == ConnectionState.done) {

          //streamBuilder can check the login state live
          return StreamBuilder(stream:
            FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {

            //if snapshot has error
              if(streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              //connection state active = do the user login check inside the
              //if statement
              if(streamSnapshot.connectionState == ConnectionState.active) {
                //get the user data
                //get the user data
                User _user = streamSnapshot.data;

                //if the user us null, we're not logged in
                if (_user == null) {
                  //user is not logged in
                  return LoginPage();

                } else {
                  // the user is logged in, return to homepage
                  return HomePage();
                }
              }

              //checking the auth state
              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication..."),
                ),
              );
            },


          );
        }

        //connecting to firebase = loading
        return Scaffold(
          body: Center(
            child: Text("Initializing App..."),
          ),
        );
      },
    );
  }

}
