import 'package:flutter/material.dart';
import 'bot_service.dart';
import 'chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'user': _controller.text,
          'bot': BotService.getResponse(_controller.text)
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Stress Bot'),
        backgroundColor: Color(0xFF436286),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatBubble(
                      message: "You: ${_messages[index]['user']}",
                      isUser: true,
                    ),
                    ChatBubble(
                      message: "Bot: ${_messages[index]['bot']}",
                      isUser: false,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        InputDecoration(hintText: "Ask me something..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF436286)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
