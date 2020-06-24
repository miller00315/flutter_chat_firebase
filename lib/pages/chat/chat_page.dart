import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/domain/repositories/firebase_repository.dart';
import 'package:firebase_chat/pages/chat/chat_page_body.dart';
import 'package:firebase_chat/pages/chat/chat_page_footer.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Repository _repository;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser _currentUser;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _repository = Repository();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  void _sendMessage(String text) {
    _repository.sendTextMessageToApi(text, _showMessage);
  }

  void _sendFile(File file, String message) {
    _repository.sendFileMessageToApi(
        file, this._showMessage, message, _onSuccessUpload);

    setState(() {
      _isLoading = true;
    });
  }

  void _onSuccessUpload() {
    setState(() {
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    this._scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
  }

  void _logout() {
    _repository.logout(_showMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        title: Text(_currentUser != null
            ? 'Olá, ${_currentUser.displayName}'
            : 'Chat App'),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          _currentUser != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => this._logout(),
                )
              : Container()
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ChatPageBody(
                listenMessagesFromApi: _repository.listenMessagesFromApi,
                currentUserUid: _currentUser?.uid ?? '',
              ),
            ),
            _isLoading ? LinearProgressIndicator() : Container(),
            ChatPageFooter(
              sendMessage: this._sendMessage,
              sendFile: this._sendFile,
            ),
          ],
        ),
      ),
    );
  }
}
