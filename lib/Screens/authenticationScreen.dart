import 'package:chat_task/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInUser() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return; //if the user does not select any option for google sign in
    }

    //getting user's information by google account
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //using that information for signing in to firebase
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    //checking if the user already exists or not
    DocumentSnapshot userExists =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    if (userExists.exists) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User already exists.")));
    } else {
      //storing user information to firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
    }

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/chatIcon.png"))),
                ),
              ),
              const Text(
                "Chat App",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () async {
                    await signInUser();
                  },
                  child: const Text(
                    "Sign in With Google",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
