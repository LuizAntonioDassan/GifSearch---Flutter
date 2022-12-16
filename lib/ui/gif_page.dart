import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget{

  final Map _gifdata;

  GifPage(this._gifdata);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("teste"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            Share.share(_gifdata["images"]["fixed_height"]['url']);
          }, icon: Icon(Icons.share))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifdata["images"]["fixed_height"]['url']),
      ),
    );
  }
}