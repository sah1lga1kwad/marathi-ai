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
      apiKey: 'AIzaSyC18AFSkUIfIYTsNyf-6cwWf2W53gUo1cE', enableDebugging: true);

  String cred = r'''{
    "type": "service_account",
    "project_id": "marathi-ai-20122023",
    "private_key_id": "0039eecc91f153ce70cfee30e20c927b3e451814",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCgnjlyJJ8FJWdk\nbaU1VkmjNq5SAJzZ3wxJKVXLt70dFrRhDY52Nta9CusVj98tejREErgUtoVJ9tWl\nZ0/lC0D6LheaD08YVY0RPxfHLtuC6BlLx+BFwWhGLpRpQgtL/EyAJShH16QHjyvM\nPEHH4KZj7YiqxcH4mgQ5CDo1M69VV5fsN0691PVZvvJx+A4IKigH7AT+DhjY1pEs\nv4GuRRAQQ4UlYGu4+txL+0XXX2OCI8RjpThDfT515sPQdDRmdFokRH4MIzpmeKB0\nTyUyOKGbKEaE+4sHySu1bIBuOWSJkngaltIkaITJTlPkyU6dQP8l08vm9CM83G6p\nVRP9/d87AgMBAAECggEAK/TRVN8X0/E2GAJ3zZ6FPZEX6OI5CtkjhBw3Wi65Jy5R\nBCSRIeIFJ6xGxNpgYhJJHn4e+bAvzxupwYACGfVX/X/CvstEwqybFCa3q6+zrGI3\nlgkn4/83uclCnYHRFKUCDKnemba2scjpXBX7jKd68esOVWoUmSQRVshdIbU43TpR\nf4nWmemX+SD3XbJApTWY1GfzgovLHOh7J7l9iA7po9/Avquc7Hfwu5QNLZDzYt79\nCyQnQQpmmmqo7FexcM9vdVh2CgvsmHc2dpqW+xdi/KeUG6zaFtaonHDrrvWw37+X\nKfMhdYst7Tuj3KUlbTH82jZTenr4Ug0qDAR/f+sLFQKBgQDhjp1kr81z/aF8zdpM\nXi9Jr5T2/w4bAe/dVXMLt8D2h5KnVL7Zct51s82K2DN94cv1e9x7HhdYdU9KgZS4\nQf11l3KtPjUbcRzbvcs3JrJpcEuZKqwehR6bbh6Eb7KQ+QGL2iFuAXQgob4VPGF0\nzN+fQDayuMqcznJeyLR7EacE9QKBgQC2S9rI5Ol/R6XexO3UK4HfZOWIWsX9TSPy\n2Q1ebOvqDKvOC0LSy6Pm8Lgr3JtO9Y6Kaa0V8B0EPjhoi0MPHYIHgGVReo2ESWGi\nwlyKkkJ4QReD71p0EpTDATGB2C7crdsGOLuCqFvUrDnwgc9z+59taTRWFJXG9f14\nBT65gNw1bwKBgQCtCYC7rpb6RfhuS2oOLi8u41Fvj0nd9EV00kn5ElYpiuY6Eqx7\nG0GIoJCt1KDkEKYsxIHnvbUBOrXCndhe5tkwLiheuZt6WvNdrKPKwpgahXipn2/9\n1fgeG4Oz7BDcYPsLtCLzRpA1PIAbwH+vYECp5lRQFa3yT/qztlunEmrERQKBgEUn\nH1bIJ5+F8XFBaSrsWjcBUmVYcfT192YfWofwb8n4hpACC5Zlc8aemG7jH/NjCXCO\nR/+jd45tf/6Ana61NedcmJLBF8AQCj6w1mQmuZperun4uWqAxff3ku07sgM63HRO\nvysAbN2Pe+c1hxnrYP4jQ5xH8M1p8X4/Fx1Nubt3AoGAGGY/q4lAA0p7LdZoaG89\nGJzAvdyGEFSXNgv7tkfW8NdB1dBh//clhkqvu+QG9iI1u/Xyb0HZ6tigYa9dHGuV\nV3p1u8vtYfTQTxp5JNEn/uOZ/TvSsheRvSIAgsLOIGIWEHAjnqXWYfySGyjXYUnt\noAKg70+BJzqk02g+IJmWuMY=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "marathi-ai-translate@marathi-ai-20122023.iam.gserviceaccount.com",
    "client_id": "111117297156884389385",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/marathi-ai-translate%40marathi-ai-20122023.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }''';
  // GOOGLE AUTH CREDENTIALS
  const projects = "projects/241424223783";
  initTranslate(cred, projects);

  runApp(
    const MaterialApp(
      home: AuthPage(),
    ),
  );
}