import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'player_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

List<SearchSong> songsList = [];
String value = "Eminem";
TextEditingController controller = TextEditingController();

class SearchPageState extends State<SearchPage> {
  List<SearchSong> apiSongsList = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    labelText: 'Input Artist or name song',
                  ),
                  onSubmitted: (String text) async {
                        _getListFromAPI(text);
                        print(value);
                  }),
              Column(
                children: searchList(),
              )
            ]),
          ),
        ),
      ),
    );
  }

  searchList() {
    return songsList
        .map((song) => MultiProvider(
              providers: [
                StreamProvider<Duration>.value(
                    initialData: Duration(),
                    value: advancedPlayer.onAudioPositionChanged),
              ],
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(border: Border.all(width: 1.0)),
                child: Row(children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Atrist: ")),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Song: ${song.titleShort}")),
                    PlayerWidget(url: song.url)
                  ]),
                ]),
              ),
            ))
        .toList();
  }

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  _getListFromAPI(query) async {
    songsList = [];
    apiSongsList = [];
    var url = "https://deezerdevs-deezer.p.rapidapi.com/search?q=" + query;
    final response = await http.get(url, headers: {
      "x-rapidapi-host": "deezerdevs-deezer.p.rapidapi.com",
      "x-rapidapi-key": "245c817282mshe47a2c1c57de405p17f8ffjsn0619c8ecc9d4"
    });
    if (response.statusCode == 200 && response.statusCode != null) {
      var allData = (json.decode(response.body) as Map)["data"];
      allData.forEach((dynamic val) {
        print(val);
        var record = SearchSong(
          titleShort: val["title"],
          url: val["preview"],
        );
        apiSongsList.add(record);
      });
      setState(() {
        songsList = apiSongsList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getListFromAPI(value);
  }
}

class SearchSong {
  String titleShort;
  String url;

  SearchSong({this.titleShort, this.url});
}
