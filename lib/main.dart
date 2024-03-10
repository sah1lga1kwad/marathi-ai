//Pages

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:marathi_ai/features/authentication/auth_frontend.dart';
// import 'package:marathi_ai/features/search/searchnewpage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:marathi_ai/features/translate/translate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
      apiKey: 'AE', enableDebugging: true);

  String cred = r'''{
    "type": "service_account",
    "pr
  }''';
  // GOOGLE AUTH CREDENTIALS
  const projects = "projects/2413";
  initTranslate(cred, projects);

  runApp(
    const MaterialApp(
      home: AuthPage(),
    ),
  );
}
