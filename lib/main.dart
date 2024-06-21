import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late Future<Album> album;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    album = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Http request with Flutter'),
          ),
          body: Center(
              child: FutureBuilder<Album>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.title);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    return const CircularProgressIndicator();
                  },
                  future: fetchAlbum()))),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

// Factory Keyword
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json['userId'], id: json['id'], title: json['title']);
  }
}

Future<Album> fetchAlbum() async {
  try {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/9999'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Album.fromJson(json);
    }
  } catch (error) {
    print(error);
  }

  throw Exception('Failure to load Album');
}
