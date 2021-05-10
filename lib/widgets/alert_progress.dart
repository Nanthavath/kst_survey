import 'package:flutter/material.dart';

class AlertProgress {
  BuildContext context;
  String message;

  AlertProgress({this.context, this.message});

  void loadingAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 15,
              ),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
  }

  void errorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void optionDialog({VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning,color: Colors.yellow,),
              SizedBox(width: 15,),
              Text("Are you sure?"),
            ],
          ),
          content: Text("Do you want to Log out?"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('Cancel')),
            TextButton(
              onPressed: onPressed,
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.done,
                    size: 30,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text('Successfully'),
            ],
          ),
        );
      },
    );
  }
}
