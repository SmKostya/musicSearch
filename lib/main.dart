import 'package:flutter/material.dart';
import 'search.dart';

void main() => runApp(MusicSearch());

class MusicSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: "Unsplash Gallery",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
  
}

