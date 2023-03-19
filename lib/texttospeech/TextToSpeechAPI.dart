import 'dart:io';
import 'dart:async';
import 'dart:convert' show json, utf8;
import 'voice.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

class TextToSpeechAPI {
  static final TextToSpeechAPI _singleton = TextToSpeechAPI._internal();
  final _httpClient = HttpClient();
  static const _apiKey = "AIzaSyAIKzZ4MSj5t0QkQOKpDDP2MfBFh6o1bas";
  static const _apiURL = "texttospeech.googleapis.com";

  factory TextToSpeechAPI() {
    return _singleton;
  }

  TextToSpeechAPI._internal();

  Future<dynamic> synthesizeText(String text, voicename, ssmlGender) async {
    try {
      final uri = Uri.https(_apiURL, '/v1/text:synthesize');
      // final Map json = {
      //   'input': {'text': text},
      //   'voice': {
      //     'name': 'ms-MY-Wavenet-D',
      //     'ssmlGender': 'MALE',
      //     'languageCode': 'ms-MY'
      //   },
      //   'audioConfig': {'audioEncoding': 'MP3'}
      // };
      final Map json = {
        'input': {'text': text},
        'voice': {
          'name': voicename,
          'ssmlGender': ssmlGender,
          'languageCode': 'ms-MY',
        },
        'audioConfig': {'audioEncoding': 'MP3'}
      };

      final jsonResponse = await _postJson(uri, json);
      print(json);
      if (jsonResponse == null) return null;
      final String audioContent = await jsonResponse['audioContent'];
      return audioContent;
    } on Exception catch (e) {
      print("$e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _postJson(Uri uri, Map jsonMap) async {
    try {
      final httpRequest = await _httpClient.postUrl(uri);
      final jsonData = utf8.encode(json.encode(jsonMap));
      final jsonResponse =
          await _processRequestIntoJsonResponse(httpRequest, jsonData);
      return jsonResponse;
    } on Exception catch (e) {
      print("$e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _processRequestIntoJsonResponse(
      HttpClientRequest httpRequest, List<int> data) async {
    try {
      httpRequest.headers.add('X-Goog-Api-Key', _apiKey);
      httpRequest.headers
          .add(HttpHeaders.contentTypeHeader, 'application/json');
      if (data != null) {
        httpRequest.add(data);
      }
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.ok) {
        throw Exception('Bad Response');
      }
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print("$e");
      return null;
    }
  }
}
