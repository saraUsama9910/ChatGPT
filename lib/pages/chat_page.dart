import 'dart:js_interop';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/constants/constants.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true
  );
  // final _openAI = OpenAI.instance.build(
  //   token: OPENAI_API_KEY,
  //   baseOption: HttpSetup(
  //     receiveTimeout: const Duration(seconds: 5),
  //   ),
  // );
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Sara', lastName: 'Mostafa');
  final ChatUser _currentBotUser =
      ChatUser(id: '1', firstName: 'Chat', lastName: 'Bot');
  final List<ChatMessage> _messages = <ChatMessage>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 100, 243),
        title: const Text(
          'ChatBot',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
          currentUser: _currentUser,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Color.fromARGB(255, 48, 60, 230),
            containerColor: Color.fromARGB(255, 75, 117, 255),
            textColor: Colors.white,
          ),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    print(m.text);
    setState(() {
      _messages.insert(0, m);
    });
  }
}
