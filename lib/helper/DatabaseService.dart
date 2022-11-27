import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/helper_function.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection("students");

  final CollectionReference professorCollection =
      FirebaseFirestore.instance.collection("professors");

  // saving the userdata
  Future savingstuData(String userName, String email, String stuid) async {
    return await studentCollection.doc(uid).set({
      "username": userName,
      "email": email,
      "projects": [],
      "uid": uid,
      "stu_id": stuid,
    });
  }

  Future savingproData(String userName, String email) async {
    return await studentCollection.doc(uid).set({
      "username": userName,
      "email": email,
      "projects": [],
      "uid": uid,
    });
  }

  // getting user data
  Future gettingstuData(String email) async {
    QuerySnapshot snapshot =
        await studentCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future gettingproData(String email) async {
    QuerySnapshot snapshot =
        await professorCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getUserName() async {
    return studentCollection.doc(uid).get();
  }

  getstuprojects() async {
    return studentCollection.doc(uid).snapshots();
  }
}
