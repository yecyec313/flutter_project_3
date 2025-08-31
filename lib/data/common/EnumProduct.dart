// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Enumproduct {
  yes,
  no,
  invalid,
  yes2,
}

class Global {
  static Enumproduct enumproduct = Enumproduct.invalid;
  static ValueNotifier<Enumproduct?> enumListener =
      ValueNotifier<Enumproduct>(Enumproduct.no);
}
