// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';

// import 'package:chatbotflutter/model/message.dart';
// import 'package:chatbotflutter/provider/messagesprovider.dart';
// import 'package:chatbotflutter/texttospeech/TextToSpeechAPI.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:provider/provider.dart';
// import 'package:audioplayer/audioplayer.dart';
// import 'package:path_provider/path_provider.dart';

// class OpenEndedPage extends StatefulWidget {
//   @override
//   _OpenEndedPageState createState() => _OpenEndedPageState();
// }

// class _OpenEndedPageState extends State<OpenEndedPage> {
//   final TextEditingController _textController = TextEditingController();
//   String _chatbotResponse = '';
//   void _submitMessage() {
//     String user_input = _textController.text;
//     _textController.clear();
//     _audioFiles.add({'name': "Hello!"});
//     setState(() {
//       _chatbotResponse = 'Loading...';
//       Provider.of<MessagesNotifier>(context, listen: false).add_Open_Message(
//         Messages(response: user_input, type: MessageType.user),
//       );
//     });

//     _getChatbotResponse(user_input).then((response) {
//       setState(() {
//         var text = "";
//         _chatbotResponse = response;

//         var responseJson = json.decode(response);
//         text = responseJson['choices'][0]['text'];
//         List<String> splitText = text.split("\n\n");
//         if (splitText.length > 1) {
//           text = splitText[1].trim();
//         }
//         Provider.of<MessagesNotifier>(context, listen: false).add_Open_Message(
//           Messages(response: text, type: MessageType.chatbot),
//         );
//         synthesizeText(text);
//       });
//     });
//   }

//   Future<String> _getChatbotResponse(String user_input) async {
 //     String model = 'text-davinci-003';
//     String url = 'https://api.openai.com/v1/completions';

//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $apiKey'
//     };

//     var program_rules =
//         "Follow these rule. \n1. Pretend you are a language teacher. \n 2. Answer the question to teach Malay(Malaysia) to a foreigner student. \n 3. Give answer examples in Bahasa Malay(Malaysia), but must explain the answer first in English.\n4. Answer only Malay(Malaysia) language related topic, if topic is unrelated say sorry. \n5. Use casual conversational vocabulary.  \n6. If the Malay(Malaysia) word contains 'permisi', replace with 'Maaf'";
//     //Use the previous prompt as context and the user's input as the prompt
//     var program_input = "rules when answering:" +
//         program_rules +
//         "\nuser input:" +
//         user_input +
//         "just directly give the answer";

//     Map<String, dynamic> body = {
//       "model": model,
//       "prompt": program_input,
//       "temperature": 0.7,
//       "max_tokens": 256,
//       "top_p": 1,
//       "frequency_penalty": 0,
//       "presence_penalty": 0
//     };

//     String jsonBody = json.encode(body);

//     http.Response response =
//         await http.post(Uri.parse(url), headers: headers, body: jsonBody);
//     return response.body;
//   }

//   AudioPlayer audioPlugin = AudioPlayer();
//   // The controller for the input field.
//   final TextEditingController _controller = TextEditingController();

//   // The user's input.
//   String _input = '';

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   // The list of audio files and their names.
//   List<Map<String, dynamic>> _audioFiles = [];

//   @override
//   Widget build(BuildContext context) {
//     final messagesNotifier = Provider.of<MessagesNotifier>(context);
//     Color chatbotbubblecolor = Colors.blue;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: chatbotbubblecolor,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Navigate back to the previous page
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           children: [
//             Text('Open Ended Mode'),
//             Icon(Icons.chat),
//           ],
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(child:
//               Consumer<MessagesNotifier>(builder: (context, notifier, _) {
//             return Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _audioFiles.length,
//                 itemBuilder: (context, index) {
//                   Messages message = notifier.openmessages[index];
//                   bool sentByMe = message.type == MessageType.user;

//                   if (message.type == MessageType.chatbot) {
//                     final file = _audioFiles[index];

//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: chatbotbubblecolor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   Text(file['name']),
//                                   IconButton(
//                                     onPressed: () async {
//                                       await audioPlugin.play(file['path'],
//                                           isLocal: true);
//                                     },
//                                     icon: Icon(Icons.play_arrow_rounded),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(child: SizedBox()),
//                       ],
//                     );
//                   } else {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(child: SizedBox()),
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(message.response),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             );
//           })),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Flexible(
//                   child: TextField(
//                     controller: _textController,
//                     decoration: InputDecoration(
//                       hintText: "Enter your message",
//                       filled: true,
//                       fillColor: Color.fromRGBO(235, 235, 245, 0.6),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.0),
//                 IconButton(
//                     onPressed: () {
//                       _submitMessage();
//                       setState(() {
//                         _input = _controller.text;
//                       });
//                     },
//                     icon: Icon(Icons.send))
//               ],
//             ),
//           ),
    
    
//         ],
//       ),
//     );
//   }

//   void synthesizeText(String text) async {
//     if (audioPlugin.state == AudioPlayerState.PLAYING) {
//       await audioPlugin.stop();
//     }

//     final String audioContent = await TextToSpeechAPI().synthesizeText(text);
//     if (audioContent == null) return;

//     final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
//     final dir = await getTemporaryDirectory();
//     // Generate a unique file name by including a timestamp.
//     final file = File(
//         '${dir.path}/wavenet_${DateTime.now().millisecondsSinceEpoch}.mp3');
//     await file.writeAsBytes(bytes);
//     if (file.existsSync()) {
//       // The file exists.
//       await file.writeAsBytes(bytes);

//       // Add the new audio file to the list of audio files.
//       setState(() {
//         _audioFiles.add({'name': text, 'path': file.path});
//       });
//     } else {
//       // The file does not exist.
//       print("File not found: ${file.path}");
//     }
//   }
// }
