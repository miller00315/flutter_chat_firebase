import 'package:firebase_chat/helpers/timeHelper.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool mine;

  const ChatMessage(this.data, this.mine);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          !this.mine
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['photoUrl']),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  this.mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data['message'],
                  style: TextStyle(fontSize: 16),
                  textAlign: mine ? TextAlign.end : TextAlign.start,
                ),
                data['type'] == 'file'
                    ? Image.network(
                        data['downloadUrl'],
                        width: 250,
                      )
                    : Container(),
                Text(
                  data['displayName'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formatDate(data['timestamp']),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          this.mine
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      data['photoUrl'],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
