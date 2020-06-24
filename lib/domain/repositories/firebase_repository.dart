import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/api/firebase.dart';

class Repository {
  FirebaseApi _firebaseApi;

  Repository() {
    _firebaseApi = FirebaseApi();
  }

  Stream listenMessagesFromApi(String collection) {
    return _firebaseApi.listenMessages(collection);
  }

  void sendTextMessageToApi(
      String message, Function(String) errorMessage) async {
    final firebaseUser = await getUser();

    if (firebaseUser == null) {
      errorMessage('Não foi possivel realizar o login');
      return;
    }

    _firebaseApi.sendMessage(
      collection: 'messages',
      data: {
        'message': message,
        'type': 'text',
        'uid': firebaseUser.uid,
        'displayName': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  void sendFileMessageToApi(
    File file,
    Function(String) errorMessage,
    String message,
    Function onSuccess,
  ) async {
    final firebaseUser = await getUser();

    if (firebaseUser == null) {
      errorMessage('Não foi possivel realizar o login');
      return;
    }

    String downloadUrl = await _firebaseApi.uploadFile(file, firebaseUser.uid);

    onSuccess();

    _firebaseApi.sendMessage(
      collection: 'messages',
      data: {
        'message': message ?? 'Arquivo',
        'type': 'file',
        'uid': firebaseUser.uid,
        'displayName': firebaseUser.displayName,
        'photoUrl': firebaseUser.photoUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'downloadUrl': downloadUrl,
      },
    );
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseApi.getUser();
  }

  void logout(Function(String) callBack) async {
    await _firebaseApi.logout();

    callBack('Você saiu da aplicação');
  }
}
