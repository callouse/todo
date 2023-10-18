import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth/authscreen.dart';
import 'package:todo/screens/home.dart'; 

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
   runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.purple),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, usersnapshot){
        if(usersnapshot.hasData){
          return Home(); 
        }
        else{
          return AuthScreen(); 
        }
      },)
    );
  }
}