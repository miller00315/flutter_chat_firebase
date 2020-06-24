import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';

class ChatPageBody extends StatelessWidget {
  final Function(String) listenMessagesFromApi;
  final String currentUserUid;

  const ChatPageBody(
      {Key key,
      @required this.listenMessagesFromApi,
      @required this.currentUserUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: listenMessagesFromApi('messages'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            {
              List<DocumentSnapshot> documents =
                  snapshot.data.documents.reversed.toList();

              return ListView.builder(
                itemCount: documents.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return ChatMessage(documents[index].data,
                      documents[index].data['uid'] == currentUserUid);
                },
              );
            }
        }
      },
    );
  }
}
