import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:userme/constants/firebase_collections.dart';
import 'package:userme/models/user_model.dart';

class AppState with ChangeNotifier {
  UserModel? user;
  login(String email, String password, BuildContext context) async {
    try {
      var auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  logout(BuildContext context) async {
    try {
      var auth = FirebaseAuth.instance;
      await auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  signup(String email, String username, String password,
      BuildContext context) async {
    try {
      var auth = FirebaseAuth.instance;
      var user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user.user != null) {
        var newUser =
            UserModel(fullName: username, email: email, id: user.user!.uid);
        var firestore = FirebaseFirestore.instance;
        await firestore
            .collection(FirebaseCollections.userCollection)
            .doc(newUser.id)
            .set(newUser.toMap());
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  updateUser(UserModel user, BuildContext context) async {
    try {
      var firestore = FirebaseFirestore.instance;
      await firestore
          .collection(FirebaseCollections.userCollection)
          .doc(user.id)
          .update(user.toMap());
      this.user = user;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getUser() async {
    var auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;
    var userdoc = await firestore
        .collection(FirebaseCollections.userCollection)
        .doc(auth.currentUser!.uid)
        .get();
    if (userdoc.exists) {
      user = UserModel.fromMap(userdoc.data()!);
      notifyListeners();
    }
  }

  uploadProfileImage(File image) async {
    try {
      var storage = FirebaseStorage.instance;
      var imageRef =
          storage.ref("userProfileImages").child("${user!.id}/${user!.id}.jpg");
      var uploadTask = await imageRef.putFile(image);
      var url = await uploadTask.ref.getDownloadURL();
      user = user!.copyWith(profileImageUrl: url);
      notifyListeners();
    } catch (e) {
      log("Upload Error");
    }
  }

  removeProfileImage(BuildContext  context) async {

    try {
  var storage = FirebaseStorage.instance;
  var  imageRef =
        storage.ref("userProfileImages").child("${user!.id}/${user!.id}.jpg");
        await imageRef.delete();
        user = user!.copyWith(profileImageUrl: "");
        // ignore: use_build_context_synchronously
        await updateUser(user!, context);
        
} on Exception catch (e) {
  log("Remove Image Error $e");
  
  
  
}
  }
}
