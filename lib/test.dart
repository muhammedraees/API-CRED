// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future<Postmodel> getdata() async {
//   final response =
//       await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));
//   if (response.statusCode == 200) {
//     return Postmodel.Jsomfrom(json.decode(response.body));
//   } else {
//     throw Exception('failed');
//   }
// }

// class Postmodel {
//   final int id;
//   final String body;
//   final String title;
//   final String userId;

//   Postmodel({
//     required this.id,
//     required this.body,
//     required this.title,
//     required this.userId,
//   });

//   factory Postmodel.Jsomfrom(Map<String, dynamic> json) {
//     return Postmodel(
//         id: json['id'],
//         body: json['body'],
//         title: json['title'],
//         userId: json['userId']);
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'API POST Example',
      home:  PostDataScreen(),
    );
  }
}

class PostModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  PostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class PostDataScreen extends StatefulWidget {
  const PostDataScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostDataScreenState createState() => _PostDataScreenState();
}

class _PostDataScreenState extends State<PostDataScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  Future<void> postData() async {
    const String apiUrl = "https://jsonplaceholder.typicode.com/posts";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        PostModel(
          userId: 1,
          id: 101,
          title: titleController.text,
          body: bodyController.text,
        ).toJson(),
      ),
    );

    if (response.statusCode == 201) {
      print("Post Successful!");
      print(response.body);
    } else {
      print("Post Failed!");
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API POST Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: "Body"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: postData,
              child: const Text("Post Data"),
            ),
          ],
        ),
      ),
    );
  }
}