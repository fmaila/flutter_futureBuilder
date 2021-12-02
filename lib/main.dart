import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import 'models/Gif.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();


}

class _MyAppState extends State<MyApp> {
  Future<List<Gif>>? _listGif ;

  Future<List<Gif>> _getGifs() async{

    var url= Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=xictvg07oFGIK6jnutZRa7GhUjD6rL0Z&limit=10&rating=g");
final response = await http.get(url);
List<Gif> _gifs=[];

if(response.statusCode == 200){

  String body= utf8.decode(response.bodyBytes);
  final jsonData = jsonDecode(body);
  for(var item in jsonData["data"]){
    _gifs.add(
        Gif(item["title"],item["images"]["downsized"]["url"])
    );
  }

  return _gifs;

}else{
  throw Exception("Existio un error");
}

  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listGif = _getGifs();

    print(_listGif.hashCode);

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(title: Text("Future Builder"),),
        body: FutureBuilder(
          future: _listGif,
          builder: (context,snapshot) {
            if(snapshot.hasData){

              print(snapshot.data);
              return GridView.count(
                crossAxisCount: 2,

                children:
                  _lisGifs(snapshot.data),
              );
            }else if(!snapshot.hasError){
              print(snapshot.error);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },

        ),
      ),
    );
  }

  List<Widget> _lisGifs(data){
    List<Widget> gifs =[];

    for(var item in data){
      gifs.add(
        Card(child: Column(
          children: [
            Expanded(child: Image.network(item.url!,fit: BoxFit.fill,)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.name!),
            ),
          ],
        ))

      );
    }
return gifs;
  }
}
