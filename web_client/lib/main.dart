import 'package:flutter/material.dart';
import 'package:web_client/domain/environment.dart';
import 'package:web_client/widgets/app.dart';

void main() => runApp(const MyApp(environment: Environment.production));
