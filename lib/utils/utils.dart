import 'package:flutter/foundation.dart';

toEnum(List values, String value) {
  for (var item in values) {
    if (describeEnum(item) == value.trim()) {
      return item;
    }
  }
  return null;
}
