import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;

  FirebaseApi() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      _currentUser = user;
    });
  }

  void sendMessage({
    @required String collection,
    @required Map<String, dynamic> data,
  }) {
    Firestore.instance.collection(collection).add(data);
  }

  void updateMessage(
    String collection,
    String document,
    Map<String, dynamic> data,
  ) {
    Firestore.instance
        .collection(collection)
        .document(document)
        .updateData(data);
  }

  void addFilesToMessage(
    String collection,
    String document,
    String subCollection,
    Map<String, dynamic> data,
  ) {
    Firestore.instance
        .collection(collection)
        .document(document)
        .collection(subCollection)
        .document()
        .setData(data);
  }

  Future<List<DocumentSnapshot>> readMessagesOnce(String collection) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection(collection).getDocuments();

    return snapshot.documents;
  }

  Future<DocumentSnapshot> readMessageOnce(
    String collection,
    String document,
  ) async {
    return await Firestore.instance
        .collection(collection)
        .document(document)
        .get();
  }

  Stream listenMessages(String collection) =>
      Firestore.instance.collection(collection).snapshots();

  void readDocumentOnModified(String collection, String document) {
    Firestore.instance
        .collection(collection)
        .document(document)
        .snapshots()
        .listen((snapshot) {
      print(snapshot.data);
    });
  }

  Future<String> uploadFile(File file, String userID) async {
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child(userID)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(file);

    final StorageTaskSnapshot res = await task.onComplete;

    return await res.ref.getDownloadURL();
  }

  Future<FirebaseUser> getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return authResult.user;
    } catch (error) {
      return null;
    }
  }

  Future<Null> logout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }
}
