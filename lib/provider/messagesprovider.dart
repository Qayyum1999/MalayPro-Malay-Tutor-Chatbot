import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:chatbotflutter/model/message.dart';

class MessagesNotifier with ChangeNotifier {
  List<dynamic> _openmessages = [];
  List<dynamic> _verbmessages = [];
  List<dynamic> _vocabmessages = [];
  List<dynamic> _dialoguemessages = [];

  List<dynamic> get openmessages => _openmessages;
  List<dynamic> get verbmessages => _verbmessages;
  List<dynamic> get vocabmessages => _vocabmessages;
  List<dynamic> get dialoguemessages => _dialoguemessages;
  //     'name': 'ms-MY-Wavenet-D',
  //     'ssmlGender': 'MALE',
  String _voicename = "ms-MY-Wavenet-D";
  String _gender = "MALE";
  String _avatar = "Adam";

  String get voicename => _voicename;
  String get gender => _gender;
  String get avatar => _avatar;
  DateTime _messagetimestamp = DateTime.now();

  void timeprovider(messagetimestamp) {
    _messagetimestamp = messagetimestamp;
    notifyListeners();
  }

  DateTime get messagetimestamp => _messagetimestamp;

  void selectvoice(voicename, gender, avatar) {
    _voicename = voicename;
    _gender = gender;
    _avatar = avatar;

    notifyListeners();
  }

  void add_Open_Message(dynamic message) {
    _openmessages.add(message);
    notifyListeners();
  }

  void remove_Open_Message() {
    _openmessages.clear();
    notifyListeners();
  }

  void add_Verb_Message(dynamic message) {
    _verbmessages.add(message);
    notifyListeners();
  }

  void remove_Verb_Message() {
    _verbmessages.clear();
    notifyListeners();
  }

  void add_Vocab_Message(dynamic message) {
    _vocabmessages.add(message);

    notifyListeners();
  }

  void remove_Vocab_Message() {
    _vocabmessages.clear();
    notifyListeners();
  }

  void add_Dialogue_Message(dynamic message) {
    _dialoguemessages.add(message);
    notifyListeners();
  }

  void remove_Dialogue_Message() {
    _dialoguemessages.clear();
    notifyListeners();
  }
}
