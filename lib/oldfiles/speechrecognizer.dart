// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:google_speech/speech_client_authenticator.dart';
// // import 'package:google_speech/google_speech.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:loading_indicator/loading_indicator.dart';
// // import 'dart:io';
// // import 'dart:async';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         fontFamily: 'poppins',
// //       ),
// //       home: MyHomePage(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key? key, required this.title}) : super(key: key);

// //   final String title;

// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   bool is_Transcribing = false;
// //   String content = '';

// //   void transcribe() async {
// //     setState(() {
// //       is_Transcribing = true;
// //     });
// //     final serviceAccount = ServiceAccount.fromString(
// //         '${(await rootBundle.loadString('assets/seraphic-scarab-373811-4f0b6c6072e8.json'))}');
// //     final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

// //     final config = RecognitionConfig(
// //         encoding: AudioEncoding.LINEAR16,
// //         model: RecognitionModel.basic,
// //         enableAutomaticPunctuation: true,
// //         sampleRateHertz: 16000,
// //         languageCode: 'ms-MY');

// //     final audio = await _getAudioContent('test.wav');
// //     await speechToText.recognize(config, audio).then((value) {
// //       setState(() {
// //         content = value.results
// //             .map((e) => e.alternatives.first.transcript)
// //             .join('\n');
// //       });
// //     }).whenComplete(() {
// //       setState(() {
// //         is_Transcribing = false;
// //       });
// //     });
// //   }

// //   Future<List<int>> _getAudioContent(String name) async {
// //     // final directory = await getApplicationDocumentsDirectory();
// //     // final path = directory.path + '/$name';
// //     final path = '/$name.wav';
// //     return File(path).readAsBytesSync().toList();
// //   }

// //   @override
// //   void initState() {
// //     setPermissions();
// //     super.initState();
// //   }

// //   void setPermissions() async {
// //     await Permission.manageExternalStorage.request();
// //     await Permission.storage.request();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color.fromARGB(255, 108, 96, 225),
// //       appBar: AppBar(
// //         toolbarHeight: 80,
// //         backgroundColor: Color.fromARGB(255, 108, 96, 225),
// //         elevation: 0,
// //         centerTitle: true,
// //         title: Text('Transcribe Your Audio'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Container(
// //           height: MediaQuery.of(context).size.height,
// //           width: MediaQuery.of(context).size.width,
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.only(
// //               topRight: Radius.circular(50),
// //               topLeft: Radius.circular(50),
// //             ),
// //           ),
// //           child: Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: <Widget>[
// //                 SizedBox(
// //                   height: 70,
// //                 ),
// //                 Container(
// //                   height: 200,
// //                   width: 300,
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: Colors.black),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   padding: EdgeInsets.all(5.0),
// //                   child: content == ''
// //                       ? Text(
// //                           'Your text will appear here',
// //                           style: TextStyle(color: Colors.grey),
// //                         )
// //                       : Text(
// //                           content,
// //                           style: TextStyle(fontSize: 20),
// //                         ),
// //                 ),
// //                 SizedBox(
// //                   height: 10,
// //                 ),
// //                 Container(
// //                   child: is_Transcribing
// //                       ? Expanded(
// //                           child: LoadingIndicator(
// //                             indicatorType: Indicator.ballPulse,
// //                             colors: [Colors.red, Colors.green, Colors.blue],
// //                           ),
// //                         )
// //                       : ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             elevation: 10,
// //                             primary: Color.fromARGB(255, 108, 96, 225),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(15),
// //                             ),
// //                           ),
// //                           onPressed: is_Transcribing ? () {} : transcribe,
// //                           child: is_Transcribing
// //                               ? CircularProgressIndicator()
// //                               : Text(
// //                                   'Transcribe',
// //                                   style: TextStyle(fontSize: 20),
// //                                 ),
// //                         ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;S
//   String _lastWords = '';

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   /// This has to happen only once per app
//   void _initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//     setState(() {});
//   }

//   /// Each time to start a speech recognition session
//   void _startListening() async {
//     await _speechToText.listen(onResult: _onSpeechResult);
//     setState(() {});
//   }

//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = result.recognizedWords;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Speech Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Recognized words:',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   // If listening is active show the recognized words
//                   _speechToText.isListening
//                       ? '$_lastWords'
//                       // If listening isn't active but could be tell the user
//                       // how to start it, otherwise indicate that speech
//                       // recognition is not yet ready or not supported on
//                       // the target device
//                       : _speechEnabled
//                           ? 'Tap the microphone to start listening...'
//                           : 'Speech not available',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//             // If not yet listening for speech start, otherwise stop
//             _speechToText.isNotListening ? _startListening : _stopListening,
//         tooltip: 'Listen',
//         child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
//     );
//   }
// }
