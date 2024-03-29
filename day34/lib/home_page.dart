import 'dart:convert';

import 'package:day34/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String link =
      "https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR1HZOZu6mvTDkbp6ntu2j56tM0Sk694Qt0XJXjoIa5i4rXs_X_9LtdIP7U";
  List<Exercise> allData = [];
  late Exercise exercise;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  bool isLoading = false;
  fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var responce = await http.get(Uri.parse(link));
      print("status code is ${responce.statusCode}");
      if (responce.statusCode == 200) {
        var data = jsonDecode(responce.body)["exercises"];
        for (var i in data) {
          exercise = Exercise(
              id: i["id"],
              title: i["title"],
              gif: i["gif"],
              thumbnail: i["thumbnail"],
              seconds: i["seconds"]);
          setState(() {
            allData.add(exercise);
          });
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("The problem is $e");
      showToast("Something Gone Wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: allData.length,
            itemBuilder: (context, index) {
              return Text("${allData[index].title}");
            }),
      ),
    );
  }
}

showToast(String title) {
  return Fluttertoast.showToast(
      msg: "$title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
