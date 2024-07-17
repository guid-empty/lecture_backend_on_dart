import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:web_client/domain/environment.dart';
import 'package:web_client/logging/logger.dart';
import 'package:web_client/widgets/app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await LoggerSettings.initLogging();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp(environment: Environment.production));
}
