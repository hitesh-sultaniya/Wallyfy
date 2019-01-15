import 'package:flutter/material.dart';
import 'Modals/WallpaperModal.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'FullScreenImageScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';



const String apiKey = "10810708-4f78cda91fb5ce5036136f319";
const String pixaBayUrl = "https://pixabay.com/";

class WallpaperList extends StatefulWidget {

  final String nameCategory;
  final String category;

  WallpaperList({Key key, @required this.nameCategory, @required this.category}) : super(key: key);

  @override
  _WallpaperListState createState() => _WallpaperListState();
}

class _WallpaperListState extends State<WallpaperList> {

  Future<WallpaperModal> wallPaper;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${widget.nameCategory}.txt');
  }

  Future<WallpaperModal> fetchWallpaper() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastDate = prefs.getString(widget.nameCategory);
    if(lastDate != null && DateTime.now().difference(DateTime.parse(lastDate)).inHours >= 24)
    {

      final response =
      await http.get('https://pixabay.com/api/?key=10810708-4f78cda91fb5ce5036136f319&category=${widget.nameCategory}&per_page=200&safesearch=true');
      final file = await _localFile;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      file.writeAsString(response.body);
      await prefs.setString(widget.nameCategory,DateTime.now().toString());
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        return WallpaperModal.fromJson(json.decode(response.body));
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    }
    else {

      try
      {

        final file = await _localFile;
        String contents = await file.readAsString();
        return WallpaperModal.fromJson(json.decode(contents));

      }
      catch (e)
      {
        // If we encounter an error, return 0
        final response =
        await http. get ('https://pixabay.com/api/?key=10810708-4f78cda91fb5ce5036136f319&category=${widget.nameCategory}&per_page=200&safesearch=true');
        final file = await _localFile;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        file.writeAsString(response.body);
        await prefs.setString(widget.nameCategory, DateTime.now().toString());
        if (response.statusCode == 200) {
          // If server returns an OK response, parse the JSON
          return WallpaperModal.fromJson(json.decode(response.body));
        } else {
          // If that response was not OK, throw an error.
          throw Exception('Failed to load post');
        }
      }
    }
  }




  @override
  void initState() {
    wallPaper = fetchWallpaper();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.none) {
          _showConnectivityAlert();
        }
        else if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
          if(wallPaper == null){
            setState(() {
              wallPaper = fetchWallpaper();
            });
          }
         }
      });
    });
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  Future<Null> _showConnectivityAlert() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Network Error',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Please enable mobile data or wifi to continue.',
                    style: TextStyle(fontSize: 15.0)),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _launchPixabayURL() async {
    if (await canLaunch(pixaBayUrl)) {
      await launch(pixaBayUrl);
    } else {
      throw 'Could not launch $pixaBayUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Wallpapers List'),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('images/pixabay.png'),
            onPressed: _launchPixabayURL,
            iconSize: 100.0,
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<WallpaperModal>(
          future: wallPaper,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StaggeredGridView.countBuilder(
                padding: const EdgeInsets.fromLTRB(8,8,8,90),
                crossAxisCount: 4,
                itemCount: snapshot.data.hits.length,
                itemBuilder: (context, i) {
                  String imgPath = snapshot.data.hits[i].webformatURL;
                  return new Material(
                    elevation: 8.0,
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(8.0)),
                    child: new InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                new FullScreenImageScreen(snapshot.data.hits[i])));

                      },
                      child: new Hero(
                        tag: imgPath,
                        child: new FadeInImage(
                          image: new NetworkImage(imgPath),
                          fit: BoxFit.cover,
                          placeholder: new AssetImage("images/placeholder.png"),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                new StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              );
            } else if (snapshot.hasError) {
              return Text("Some thing went wrong, Please check you internet connection!",textAlign: TextAlign.center,);
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
