import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:work_beacon/login/login.dart';
import 'package:work_beacon/screens/signup/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env optional (e.g. copy from .env.example and add MAPBOX_ACCESS_TOKEN)
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: {
        '/sign_up': (context) => SignUp(),
        // other routes...
      },
    );
  }
}
