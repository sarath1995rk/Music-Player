import 'dart:io';

import 'package:flutter/foundation.dart';

class ServerConstants {
  static String baseUrl = kIsWeb
      ? 'http://localhost:3000'
      : Platform.isAndroid
      ? "http://192.168.1.11:3000"
      // ? "http://10.0.2.2:3000"
      : 'http://localhost:3000';
}


//ipconfig getifaddr en0