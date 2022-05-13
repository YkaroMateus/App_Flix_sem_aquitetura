import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          'Favorite',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
          child: Text(
        ':(\nNo Found Favorite Movies',
        style: TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      )),
    );
  }
}
