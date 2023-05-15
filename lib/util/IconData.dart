import 'dart:convert';
import 'package:flutter/material.dart';

String iconDataToJSONString(IconData iconData){
  Map<String, dynamic> map = <String, dynamic>{};
  map['codePoint'] = iconData.codePoint;
  map['fontFamily'] = iconData.fontFamily;
  map['fontPackage'] = iconData.fontPackage;
  map['matchTextDirection'] = iconData.matchTextDirection;
  return jsonEncode(map);
}

IconData iconDatafromJSONString(String jsonString) {
  Map<String, dynamic> map = jsonDecode(jsonString);
  return IconData(
    map['codePoint'],
    fontFamily: map['fontFamily'],
    fontPackage: map['fontPackage'],
    matchTextDirection: map['matchTextDirection'],
  );
}