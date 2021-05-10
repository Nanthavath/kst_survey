import 'package:flutter/material.dart';

class AuthenScreen extends StatefulWidget {
  static String route = '/authen';
  @override
  _AuthenScreenState createState() => _AuthenScreenState();
}

class _AuthenScreenState extends State<AuthenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('create-new');
                        },
                        child: Text('Create New')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('create-new/summary');
                        },
                        child: Text('Update')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
