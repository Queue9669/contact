import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('app'),),
        body: Text('hi'),
        bottomNavigationBar: BottomAppBar(
            child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.phone),
                    Icon(Icons.message),
                    Icon(Icons.contact_page),
                  ],
                )
            )
        ),
      )
    );

  }
}
