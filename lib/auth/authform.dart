import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  
  //form key for validation 
  final _formkey = GlobalKey <FormState>(); 
  var _username = ''; 
  var _email = ''; 
  var _password = ''; 
  bool isLoginPage = false; 

  //defining a function to auth the users
  startAuthentication(){
    final validity = _formkey.currentState!.validate(); 
    FocusScope.of(context).unfocus(); 
    if(validity){
      _formkey.currentState!.save(); 
      submitForm(_email, _password, _username); 
    }
  }

  submitForm(String email, String password, String username)async{
    final auth = FirebaseAuth.instance; 
    UserCredential userCredential;
    try{
      if(isLoginPage){
        userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password
          );
      }
      else{
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password
          );
          String uid = userCredential.user!.uid; 
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'username': username,
            'email': email
          });
      }
    }
    catch(err){
      print(err); 
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10), 
      height: MediaQuery.of(context).size.height, 
      width: MediaQuery.of(context).size.width, 
      child: ListView(
        children: [
          Container(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TextFormField for Username
                  if(!isLoginPage)
                  TextFormField(
                    keyboardType: TextInputType.name,
                    key: ValueKey('username'),
                    validator: (String? value){
                      if(value!.isEmpty){
                        return 'Invalid Username'; 
                      }
                      else{
                        return null; 
                      }
                    },
                    onSaved: (String? value){
                      _username = value!; 
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0), 
                        borderSide: new BorderSide(), 
                      ), 
                      labelText: "Enter Username", 
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(height: 10), 
                  //TextFormField for email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (String? value){
                      if(value!.isEmpty || !value.contains('@')){
                        return 'Invalid Email'; 
                      }
                      else{
                        return null; 
                      }
                    },
                    onSaved: (value){
                      _email = value!; 
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0), 
                        borderSide: new BorderSide(),
                       
                      ),
                      labelText: "Enter Email", 
                      labelStyle: GoogleFonts.roboto(), 
                    ),                   
                   ), 
                   SizedBox(height:10),
                   // TextFormField for password
                   TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    key: ValueKey('password'),
                    validator: (String? value){
                      if(value!.isEmpty){
                        return 'Invalid Password'; 
                      }
                      else{
                        return null; 
                      }
                    }, 
                    onSaved: (String? value){
                      _password = value!; 
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0), 
                        borderSide: new BorderSide(),
                      ), 
                      labelText: "Enter Password", 
                      labelStyle: GoogleFonts.roboto(),
                    ),
                     
                   ),
                   //Adding a button
                   SizedBox(height: 10),
                   Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    height: 70, 
                    child: ElevatedButton(
                      child: isLoginPage? Text('Login', style: GoogleFonts.roboto())
                      : Text('SignUp', style: GoogleFonts.roboto()
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: (){
                        startAuthentication();
                      },
                     ),
                    ),
                    SizedBox(height: 10), 
                    Container(
                      child: TextButton(
                        onPressed: (){
                          setState(() {
                            isLoginPage =! isLoginPage; 
                          });
                        }, 
                        child: isLoginPage? Text('Not a member yet?'):Text('Already a member?')
                      ),
                    )
                 ],
              )
            ),
          )
        ],
      )
    );
  }
}