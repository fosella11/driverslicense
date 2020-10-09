import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:driverslicenses/models/category.dart';
import 'package:driverslicenses/models/question.dart';

const String baseUrl = "http://broadclump.com/";

Future<List<Question>> getQuestions(Category category, int total, String difficulty) async {
  String url = "$baseUrl${category.url}";
  http.Response res = await http.get(url);
  String body = utf8.decode(res.bodyBytes);
  List<Map<String, dynamic>> questions = List<Map<String,dynamic>>.from(json.decode(body)["results"]);
  questions.shuffle();
  /*List numberOfQuestions;
  questions.forEach((element) {
    if(numberOfQuestions.length >= total){
      numberOfQuestions.add(element);
    }else{
      return;
    }
  });*/
  return Question.fromData(questions.sublist(0, total));
}