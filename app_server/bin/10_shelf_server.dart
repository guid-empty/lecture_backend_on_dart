import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

///
/// http://localhost:8080/json
/// http://localhost:8080/echo/somemessage
/// http://localhost:8080/echo/somemessage/error
/// 
void main(List<String> _) => serve(
    (request) => Response.ok('Hello, World!\n'), InternetAddress.anyIPv4, 8080);
