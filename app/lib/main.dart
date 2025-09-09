import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'Community Knowledge Hub',
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();
  List results = [];

  Future<void> doSearch(String q) async {
    final uri = Uri.parse('http://127.0.0.1:3000/search?q=${Uri.encodeQueryComponent(q)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      setState(() {
        results = json.decode(res.body);
      });
    }
  }

  @override Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text('Community Knowledge Hub')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children:[
                Expanded(child: TextField(controller: _ctrl, decoration: InputDecoration(hintText: 'Search...'))),
                IconButton(icon: Icon(Icons.search), onPressed: () => doSearch(_ctrl.text))
              ]
            )
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (c,i){
                final item = results[i];
                return ListTile(
                  title: Text(item['title'] ?? ''),
                  subtitle: MarkdownBody(data: item['snippet'] ?? ''),
                  onTap: (){
                    // TODO: open document viewer
                  },
                );
              }
            )
          )
        ],
      )
    );
  }
}
