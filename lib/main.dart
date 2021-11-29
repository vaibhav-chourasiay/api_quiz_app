// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quiz App",
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://opentdb.com/api.php?amount=10";
  int i = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getdata() async {
    Models.q = [];

    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    var resj = await dio.get(url);
    List data = resj.data["results"];
    for (var i in data) {
      Models ob = Models();
      ob = Models.fromMap(i);
      ob.tomap();
      // qu.add(ob.tomap());
    }
    print(Models.q.length);

    i++;
    print("$i");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: getdata(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return const ViewList();
              default:
                return const Text("default");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ViewList extends StatefulWidget {
  const ViewList({Key? key}) : super(key: key);

  @override
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${Models.q[index].question}",
                    style: GoogleFonts.lato(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FilterChip(
                            label: Text(Models.q[index].category),
                            onSelected: (b) {}),
                        const SizedBox(
                          width: 5.0,
                        ),
                        FilterChip(
                            label: Text(Models.q[index].diffeculty),
                            onSelected: (b) {}),
                      ],
                    ),
                  ),
                ],
              ),
              children: Models.q[index].total_options
                  .map<Widget>((m) => AnswerWidget(index, m))
                  .toList(),
              leading: CircleAvatar(
                child: Text(Models.q[index].type
                    .toString()
                    .substring(0, 1)
                    .toUpperCase()),
              ),
            ),
          ),
        );
      },
      itemCount: Models.q.length,
    );
  }
}

class AnswerWidget extends StatefulWidget {
  final int index;
  final String m;

  const AnswerWidget(this.index, this.m);

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          if (widget.m == Models.q[widget.index].correct_answer) {
            c = Colors.green;
          } else {
            c = Colors.red;
          }
        });
      },
      title: Text(
        widget.m,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
