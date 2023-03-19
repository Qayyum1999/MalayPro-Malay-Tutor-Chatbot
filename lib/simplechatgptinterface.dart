import 'dart:convert';
import 'package:chatbotflutter/provider/messagesprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Add this line to import the intl package
import 'package:chatbotflutter/constant.dart';

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "content": content,
    };
  }
}

Future<String> getChatGptResponse(List<Map<String, dynamic>> messages) async {
  final response = await http.post(
    Uri.parse("https://api.openai.com/v1/chat/completions"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": messages,
    }),
  );
  final jsonResponse = jsonDecode(response.body);
  final message = jsonResponse["choices"][0]["message"];
  return message["content"].toString();
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Message> _messages = [
    Message(
      role: "assistant",
      content: "Hi there! How can I help you today?",
    ),
  ];
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;
  void _handleSubmitted(String text) async {
    _textController.clear();

    setState(() {
      _messages.add(
        Message(
          role: "user",
          content: text,
        ),
      );
      _isTyping = true;
    });
    final response = await getChatGptResponse(
      _messages.map((message) => message.toJson()).toList(),
    );
    setState(() {
      _messages.add(
        Message(
          role: "assistant",
          content: response,
        ),
      );
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT API Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Montserrat",
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ChatGPT API Test'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.9],
              colors: [
                Colors.blue.shade100.withOpacity(0.2),
                Colors.blue.withOpacity(0.4),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) {
                    final message = _messages[index];
                    return _buildMessage(message);
                  },
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).accentColor),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: _handleSubmitted,
                            decoration: InputDecoration.collapsed(
                              hintText: "Send a message",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () =>
                                _handleSubmitted(_textController.text),
                          ),
                        ),
                        _isTyping
                            ? Container(
                                margin: EdgeInsets.only(left: 4.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final isUser = message.role == "user";
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          !isUser
              ? Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 16.0,
                    child: Text("CG"),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.role == "user" ? "User" : "ChatGPT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isUser
                        ? Colors.blueAccent
                        : Theme.of(context).accentColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.blueAccent
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomLeft: isUser ? Radius.circular(16.0) : Radius.zero,
                      bottomRight: isUser ? Radius.zero : Radius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isUser
              ? Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    radius: 16.0,
                    child: Text("U"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
