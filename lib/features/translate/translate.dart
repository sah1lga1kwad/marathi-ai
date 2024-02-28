// Flutter
import 'dart:developer';

// Google Auth API
import 'package:googleapis_auth/auth_io.dart';

// Google Translate API
import 'package:googleapis/translate/v3.dart' as translate;

//initialization
ServiceAccountCredentials credentials = ServiceAccountCredentials.fromJson('');
String parent = '';

// GOOGLE AUTH CREDENTIALS - initialization
void initTranslate(String cred, String projects) {
  credentials = ServiceAccountCredentials.fromJson(cred);
  parent = projects;
}

// TRANSLATE TEXT
Future<String> translateText(String q, String source, String target) async {
  var scopes = [translate.TranslateApi.cloudTranslationScope];
  var client = await clientViaServiceAccount(credentials, scopes);
  var translateApi = translate.TranslateApi(client);

  //Body Param
  var textToTranslate = q;
  var targetLanguageCode = target; // Spanish
  var sourceLanguageCode = source; // English (explicitly set)

  var requestbody = translate.TranslateTextRequest.fromJson({
    "contents": [textToTranslate],
    "sourceLanguageCode": sourceLanguageCode,
    "targetLanguageCode": targetLanguageCode,
  });

  //POST

  try {
    final response =
        await translateApi.projects.translateText(requestbody, parent);
    // Process successful response (as discussed earlier)
    final translatedText = response.translations?[0].translatedText;
    log("Translated text: $translatedText");
    return translatedText.toString();
  } catch (error) {
    // Handle errors
    log("$error");
    return "Translate Error: $error";
  }
}

//LANGUAGE DETECT
Future<String> detectLanguage(String q) async {
  var scopes = [translate.TranslateApi.cloudTranslationScope];
  var client = await clientViaServiceAccount(credentials, scopes);
  var translateApi = translate.TranslateApi(client);
  // Body Param
  String contentToDetect = q;

  var requestbody = translate.DetectLanguageRequest.fromJson({
    "content": contentToDetect,
  });

  log(q);

  try {
    final response =
        await translateApi.projects.detectLanguage(requestbody, parent);

    // Process successful response
    final detectedLang = response.languages![0].languageCode;
    log("Detected language: $detectedLang");
    return detectedLang.toString();
  } catch (error) {
    // Enhanced error logging
    log("Error during language detection: $error");
    log("Request body: $requestbody"); // Log the request body for debugging
    log("Response: "); // Log the response if available
    // Handle errors gracefully, providing informative messages
    return "Language detection failed: $error";
  }
}
