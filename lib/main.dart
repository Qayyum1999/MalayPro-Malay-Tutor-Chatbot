import 'package:chatbotflutter/dialoguepage.dart';
import 'package:chatbotflutter/home.dart';
import 'package:chatbotflutter/lmvocabspage.dart';
import 'package:chatbotflutter/lmverbpage.dart.dart';
import 'package:chatbotflutter/openendedpage.dart';
import 'package:chatbotflutter/provider/messagesprovider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() {
  //flutter run --no-sound-null-safety

  runApp(
    ChangeNotifierProvider(
      create: (context) => MessagesNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const Homepage(),
        '/firstmode': (context) => OpenEndedPage(),
        '/secondmode': (context) => VerbModePage(),
        '/thirdmode': (context) => VocabModePage(),
        '/fourthmode': (context) => DialoguePage(),
      },
    );
  }
}
