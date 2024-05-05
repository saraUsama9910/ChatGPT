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
      enableLog: true);
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
  final List<ChatUser> _typingUsers = <ChatUser>[];
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
          typingUsers: _typingUsers,
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
      _typingUsers.add(_currentBotUser);
    });
    List<Map<String, dynamic>> messagesHistory = _messages.reversed.map(
          (m) {
        if (m.user == _currentUser) {
          return {
            'role': Role.user.toString(),
            'content': m.text,
          };
        } else {
          return {
            'role': Role.assistant.toString(),
            'content': m.text,
          };
        }
      },
    ).toList();
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(
              () {
            _messages.insert(
              0,
              ChatMessage(
                  user: _currentBotUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content),
            );
          },
        );
      }
    }
    setState(() {
      _typingUsers.remove(_currentBotUser);
    });
  }
}
