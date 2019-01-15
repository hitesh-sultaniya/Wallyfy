import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lib_wallpaper/lib_wallpaper.dart';
import 'package:share/share.dart';
import 'package:wallyfy/Modals/Wallpaper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullScreenImageScreen extends StatefulWidget {

  Wallpaper currentImageModel;
  static const platform = const MethodChannel('wallyfy.lemotreeapps.com/wallpaper');
  FullScreenImageScreen(this.currentImageModel);

  @override
  _FullScreenImageScreenState createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {

  static const platform = const MethodChannel('wallyfy.lemotreeapps.com/wallpaper');

  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color(0x10000000), new Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  Future<void> _setWallPaper() async {

    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
              title: Text("Setting Wallpaper"),
              content: Container(
                width: 100.0,
                height: 100.0,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          );
        }
    );

    var cacheManager = await CacheManager.getInstance();
    var file = await cacheManager.getFile(widget.currentImageModel.fullHDURL);

    LibWallpaper.setWallpaper(file.path).then((onValue){
      if(onValue){
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg:"Wallpaper Set Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white);
      }
    });

  }

  _launchImageUrl() async {
    String url = widget.currentImageModel.pageURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _downloadWallpaper() async {
    SimplePermissions.requestPermission(Permission.WriteExternalStorage).then((onValue){

      if(onValue == PermissionStatus.authorized){
        try {
          platform.invokeMethod("downloadWallPaper",widget.currentImageModel.fullHDURL);
        } on PlatformException catch (e) {
          print(e.message);
        }

      }
      else {
        Fluttertoast.showToast(
            msg:"Permission Denied!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("WallyFy",textAlign: TextAlign.center),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.wallpaper), onPressed:(){
              _setWallPaper();
            }),
            IconButton(icon: Icon(Icons.share), onPressed: (){
              Share.share("${widget.currentImageModel.fullHDURL} \nDowload free HD Wallaper Application, Click here, \nhttp://bit.ly/2C10hwO");
            }),
            IconButton(icon: Icon(Icons.language), onPressed: (){
              _launchImageUrl();
            }),
            IconButton(icon: Icon(Icons.file_download), onPressed: (){
              _downloadWallpaper();
            })
          ],
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(gradient: backgroundGradient),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0,0,0,90),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: widget.currentImageModel.fullHDURL,
                    child: new FadeInImage(
                      image: new NetworkImage(widget.currentImageModel.fullHDURL),
                      fit: BoxFit.cover,
                      placeholder: new AssetImage("images/placeholder.png"),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      maxRadius: 18.0,
                      backgroundImage: NetworkImage(widget.currentImageModel.userImageURL),
                    ),
                    title: Text("Photo by "+widget.currentImageModel.user,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  ListTile(
                    leading: Icon(Icons.file_download,size: 20.0,),
                    title: Text(widget.currentImageModel.downloads.toString()+" Downloads",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  ListTile(
                    isThreeLine: false,
                    leading: Icon(Icons.favorite,size: 20.0,),
                    title: Text(widget.currentImageModel.likes.toString()+" Likes",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  ListTile(
                    leading: Icon(Icons.remove_red_eye,size: 20.0,),
                    title: Text(widget.currentImageModel.views.toString()+" Views",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            )
        )
    );
  }
}

