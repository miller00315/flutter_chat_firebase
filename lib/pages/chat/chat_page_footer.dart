import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPageFooter extends StatefulWidget {
  final Function(String) sendMessage;
  final Function(File, String) sendFile;

  const ChatPageFooter(
      {Key key = const Key('chat_screen'),
      @required this.sendMessage,
      @required this.sendFile})
      : super(key: key);

  @override
  _ChatPageFooterState createState() => _ChatPageFooterState();
}

class _ChatPageFooterState extends State<ChatPageFooter> {
  bool _isComposing = false;
  final _inputController = TextEditingController();
  final _picker = ImagePicker();

  void _changeComposingStatus(String text) {
    setState(() {
      _isComposing = text.isNotEmpty;
    });
  }

  void _sendMEssage() {
    widget.sendMessage(_inputController.text);

    setState(() {
      _inputController.clear();
      _isComposing = false;
    });
  }

  Future _takePicture() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    widget.sendFile(File(pickedFile.path), _inputController.text);

    setState(() {
      _inputController.clear();
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () => _takePicture(),
          ),
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration.collapsed(
                hintText: 'Entre com uma mensagem',
              ),
              onChanged: (text) => this._changeComposingStatus(text),
              onSubmitted: (text) => _sendMEssage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: this._isComposing ? () => _sendMEssage() : null,
          ),
        ],
      ),
    );
  }
}
