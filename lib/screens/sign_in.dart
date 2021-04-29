import 'package:flutter/material.dart';
import 'package:messenger_app/screens/home.dart';
import 'package:messenger_app/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SignIn'),
        ),
        body: Center(
          child:Card(
              elevation: 5.0,
              color: Colors.grey[600],
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child:  FlatButton.icon(
                onPressed: (){
                  AuthMethod().signInWithGoogle(context).then((e){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                  });
                 setState(() {

                 });
                },
                icon: Icon(Icons.email,size: 32.0,color: Colors.white,),
                label: Text(
                  "Sign In with Google",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }
}
