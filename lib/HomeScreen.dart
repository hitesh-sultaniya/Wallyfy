import 'package:flutter/material.dart';
import 'WallpaperList.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const String appId = "ca-app-pub-7650945113243356~2684802114";
const String bannerId = "ca-app-pub-7650945113243356/6292998344";
const String fullAdId = "ca-app-pub-7650945113243356/8647575231";
const String testDeviceId = "39949D93A8C833AF5E38907C5B88516D";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{

  List listCategories = [

    {"image":"images/Animal.jpg","title":"Animals","category":"animals"},
    {"image":"images/Building.jpg","title":"Architecture/Buildings","category":"buildings"},
    {"image":"images/Texture.jpg","title":"Backgrounds/Textures","category":"backgrounds"},
    {"image":"images/Beauty.jpg","title":"Beauty/Fashion","category":"fashion"},
    {"image":"images/Business.jpg","title":"Business/Finance","category":"business"},
    {"image":"images/Computers.jpg","title":"Computer/Communication","category":"computer"},
    {"image":"images/Education.jpg","title":"Education","category":"education"},
    {"image":"images/Emotions.jpg","title":"Emotions","category":"feelings"},
    {"image":"images/Food.jpg","title":"Food/Drink","category":"food"},
    {"image":"images/Health.jpg","title":"Health/Medical","category":"health"},
    {"image":"images/Industry.jpg","title":"Industry/Craft","category":"industry"},
    {"image":"images/Music.jpg","title":"Music","category":"music"},
    {"image":"images/Nature.jpg","title":"Nature/Landscapes","category":"nature"},
    {"image":"images/People.jpg","title":"People","category":"people"},
    {"image":"images/Monuments.jpg","title":"Places/Monuments","category":"places"},
    {"image":"images/Religion.jpg","title":"Religion","category":"religion"},
    {"image":"images/Science.jpg","title":"Science/Technology","category":"science"},
    {"image":"images/Sports.jpg","title":"Sports","category":"sports"},
    {"image":"images/Transportation.jpg","title":"Transportation/Traffic","category":"transportation"},
    {"image":"images/Vacations.jpg","title":"Travel/Vacation ","category":"travel"},


  ];

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(testDevices: <String>[]);
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: bannerId,
        size: AdSize.smartBanner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
         });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: fullAdId,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
    FirebaseAdMob.instance.initialize(appId: appId);
    _bannerAd = createBannerAd()..load()..show();
  }


  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  _launchPrivacyPolicy() async {
    const url = 'https://lemontreeapps.github.io/WallyFy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMoreApps() async {
    const url = 'https://play.google.com/store/apps/developer?id=Incognito+Apps';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text("WallyFy"),
            elevation: 0.7,
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('WallyFy',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                  accountEmail:Text('Free High Resolution Images',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                  currentAccountPicture: Image.asset("images/ic_launcher.png"),
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share App',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),),
                  onTap: () {
                    Share.share(
                        "Hey, Check out new HD WallPaper app\nhttp://bit.ly/2C10hwO\nFor great High Definition Wallpapers.");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.rate_review),
                  title: Text('Rate App',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),),
                  onTap: () {
                    LaunchReview.launch();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.apps),
                  title: Text('More Apps',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),),
                  onTap: () {
                    _launchMoreApps();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Privacy Policy',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0),),
                  onTap: () {
                    _launchPrivacyPolicy();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: GridView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0,90),
            itemCount: listCategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                onTap: () async {
                  _interstitialAd = createInterstitialAd();
                  _interstitialAd.load();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WallpaperList(nameCategory: listCategories[index]["category"],category: listCategories[index]["title"],)),
                  );
                  _interstitialAd.show();
                },
                child: Card(
                  child:GridTile(
                      child: Image.asset(listCategories[index]["image"],fit: BoxFit.cover,),
                      footer: Opacity(
                        opacity: 0.6,
                        child: Container(
                          height:50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(listCategories[index]["title"],style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),),
                          ),
                        ),
                      )
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}
