import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giphy/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

const TrendingURL = "https://api.giphy.com/v1/gifs/trending?api_key=pRfALJ1eDRu1iYzUNZhNWNxuBhHaEt0m&limit=25&rating=g";
const SearchURL = "https://api.giphy.com/v1/gifs/search?api_key=pRfALJ1eDRu1iYzUNZhNWNxuBhHaEt0m&q=&limit=25&offset=0&rating=g&lang=en";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? _search;

  int _offSet = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offSet = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError) { return Container();}
                      else {return _createGiftTable(context, snapshot);}
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _createGiftTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder:(context,index){
          if(_search == null || index < snapshot.data["data"].length){
            return GestureDetector(
              child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]['url'],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]['url']);
              },
            );
          }
          else{
            print("Aqui ok");
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap:(){
                  setState(() {
                    _offSet += 19;
                  });
                },
              ),
            );
          }
        }
    );
  }

  void initState(){
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  int _getCount(List data){
    if(_search == null){
      return data.length;
    }
    else{
      return data.length + 1;
    }
  }

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=pRfALJ1eDRu1iYzUNZhNWNxuBhHaEt0m&limit=25&rating=g"));
    }
    else{
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=pRfALJ1eDRu1iYzUNZhNWNxuBhHaEt0m&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en"));
    }
    return json.decode(response.body);
  }
}
