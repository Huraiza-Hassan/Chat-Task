import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String name;
  Timestamp date;
  String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.date,
    required this.uid,
  });

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
        email: snapshot['email'],
        name: snapshot['name'],
        date: snapshot['date'],
        uid: snapshot['uid']);
  }
}
