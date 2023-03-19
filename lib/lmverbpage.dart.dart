import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:chatbotflutter/constant.dart';

import 'package:chatbotflutter/model/message.dart';
import 'package:chatbotflutter/provider/messagesprovider.dart';
import 'package:chatbotflutter/texttospeech/TextToSpeechAPI.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';

import 'package:audioplayers/audioplayers.dart';

class VerbModePage extends StatefulWidget {
  @override
  _VerbModePageState createState() => _VerbModePageState();
}

class _VerbModePageState extends State<VerbModePage> {
  final TextEditingController _textController = TextEditingController();
  String _chatbotResponse = '';

  void _submitMessage() {
    String user_input = _textController.text;
    _textController.clear();
    setState(() {
      _chatbotResponse = 'Loading...';
      Provider.of<MessagesNotifier>(context, listen: false).add_Verb_Message(
        Messages(response: user_input, type: MessageType.user),
      );
    });

    _getChatbotResponse(user_input).then((response) {
      setState(() {
        var text = "";
        _chatbotResponse = response;

        var responseJson = json.decode(response);
        text = responseJson['choices'][0]['text'];
        List<String> splitText = text.split("\n\nAnswer:");
        if (splitText.length > 1) {
          text = splitText[1].trim();
        }
        Provider.of<MessagesNotifier>(context, listen: false).add_Verb_Message(
          Messages(response: text, type: MessageType.chatbot),
        );
        AudioPlayerWidget(text: text);
      });
    });
  }

  Future<String> _getChatbotResponse(String user_input) async {
    String model = 'text-davinci-003';
    String url = 'https://api.openai.com/v1/completions';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };

    var program_rules = """
        Pretends you are Malay language teacher that only teach about Malay (Malaysia) verbs. 
        You can differentiate between Bahasa Malay(Malaysia) and Bahasa Malay(Indonesia).
        Answer only malay verbs related question, other than verbs, say sorry.
        Only give the other example of verbs and sentences when received 'next' input.
        I will give you prompt in any language, and you will respond using this format:-
        Malay verbs (English Verbs)
        then give two sample sentences using that verbs with english translation separate by a number with spacing and open bracket 
        """;
    //Use the previous prompt as context and the user's input as the prompt
    var program_input = program_rules + "\nSo my prompt is " + user_input + ".";

    Map<String, dynamic> body = {
      "model": model,
      "prompt": program_input,
      "temperature": 0.7,
      "max_tokens": 256,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    };

    String jsonBody = json.encode(body);

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: jsonBody);
    return response.body;
  }

  // The controller for the input field.
  final TextEditingController _controller = TextEditingController();

  // The user's input.
  String _input = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _hasSentWelcomeMessage = false;

  @override
  Widget build(BuildContext context) {
    final messagesNotifier = Provider.of<MessagesNotifier>(context);
    Color chatbotbubblecolor = Colors.green;

    String introscript =
        "Hi! Welcome to Verb mode!\nLike English, Bahasa Malaysia also has its own set of vast vocabulary for verbs; verbs refer to the words people use to describe an action, act, or activity." +
            "\n\nHow to use Verb mode?\n1) Simply ask me the verb in English ,and i will provide you the correct verb in malay with sample sentences.\n\n2) Just simply  type , \" to (what verb) \", and i will teach the verb in malay with sample sentences." +
            "\nExample: To \"sleep\"\n\n3) Question that is not related to Verbs, I may not answer it.\n\n4) Thats it!  Enjoy your Malay Verbs learning!";

    if (Provider.of<MessagesNotifier>(context).verbmessages.isEmpty) {
      _hasSentWelcomeMessage = true;
      Provider.of<MessagesNotifier>(context, listen: false).add_Verb_Message(
        Messages(response: introscript, type: MessageType.chatbot),
      );
      Provider.of<MessagesNotifier>(context, listen: false).verbmessages.clear;
      print(_hasSentWelcomeMessage);
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: chatbotbubblecolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous page
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verb Mode',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onLongPress: () {
                    context.read<MessagesNotifier>().remove_Verb_Message();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 25,
                    // backgroundColor: Colors.green,
                    // or

                    backgroundImage:
                        Provider.of<MessagesNotifier>(context).avatar == "Adam"
                            ? AssetImage('assets/boyavatar.webp')
                            : AssetImage('assets/girlavatar.webp'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.lightGreen[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount:
                    Provider.of<MessagesNotifier>(context).verbmessages.length,
                itemBuilder: (context, index) {
                  Messages message = Provider.of<MessagesNotifier>(context)
                      .verbmessages[index];

                  return Column(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: ChatBubble(
                                  clipper: ChatBubbleClipper1(
                                      type: message.type == MessageType.user
                                          ? BubbleType.sendBubble
                                          : BubbleType.receiverBubble),
                                  alignment: message.type == MessageType.user
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 25, bottom: 10),
                                  backGroundColor:
                                      message.type == MessageType.user
                                          ? chatbotbubblecolor
                                          : Color(0xffE7E7ED),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            message.response,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: message.type ==
                                                        MessageType.user
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          message.type == MessageType.chatbot
                                              ? AudioPlayerWidget(
                                                  text: message.response,
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            Positioned(
                              top: 20,
                              left: message.type == MessageType.user ? null : 0,
                              right:
                                  message.type == MessageType.user ? 0 : null,
                              child: message.type == MessageType.user
                                  ? CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.green,
                                      backgroundImage: Provider.of<
                                                      MessagesNotifier>(context)
                                                  .avatar ==
                                              "Adam"
                                          ? AssetImage('assets/girlavatar.webp')
                                          : AssetImage('assets/boyavatar.webp'),
                                      // or
                                      // backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
                                    )
                                  : CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.orange,
                                      backgroundImage:
                                          Provider.of<MessagesNotifier>(context)
                                                      .avatar ==
                                                  "Adam"
                                              ? AssetImage(
                                                  'assets/boyavatar.webp')
                                              : AssetImage(
                                                  'assets/girlavatar.webp'),
                                      // or
                                      // backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: chatbotbubblecolor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        controller: _textController,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Enter your message",
                          hintStyle: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        minLines: 1,
                        maxLines: null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IconButton(
                        onPressed: () {
                          _submitMessage();
                          setState(() {
                            _input = _controller.text;
                            _chatbotResponse =
                                _getChatbotResponse(_input).toString();
                            _controller.clear();
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String text;

  AudioPlayerWidget({required this.text});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  String? _path;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  synthesizeText(String text) async {
    final String audioContent = await TextToSpeechAPI().synthesizeText(
      text,
      context.read<MessagesNotifier>().voicename,
      context.read<MessagesNotifier>().gender,
    );
    if (audioContent == null) return;

    final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
    final dir = await getTemporaryDirectory();
    // Generate a unique file name by including a timestamp.
    final file = File(
        '${dir.path}/wavenet_${DateTime.now().millisecondsSinceEpoch}.mp3');
    await file.writeAsBytes(bytes);
    if (file.existsSync()) {
      // The file exists.
      setState(() {
        _path = file.path;
      });
    } else {
      // The file does not exist.
      print("File not found: ${file.path}");
    }
  }

  @override
  void initState() {
    super.initState();
    synthesizeText(widget.text);
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() => _position = position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _path != null
            ? Row(
                children: [
                  IconButton(
                    icon: _isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play(_path!);
                      }
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _position.inSeconds.toDouble() ?? 0,
                      onChanged: (double value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                      min: 0,
                      max: _duration.inSeconds.toDouble() ?? 0,
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }
}
