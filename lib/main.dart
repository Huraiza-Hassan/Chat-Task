import 'package:chat_task/Models/userModel.dart';
import 'package:chat_task/Screens/authenticationScreen.dart';
import 'package:chat_task/Screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<Widget> isUserSignedIn() async {
    //checking if the user is already signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //getting user data
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      //assigning that user data to model class
      UserModel userModel = UserModel.fromJson(userData);
      return HomeScreen(
        user: userModel,
      );
    } else {
      return const AuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      home: FutureBuilder(
          future: isUserSignedIn(),
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
