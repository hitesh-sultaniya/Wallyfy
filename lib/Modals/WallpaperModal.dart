import 'Wallpaper.dart';


class WallpaperModal {

  final int totalHits;
  final List<Wallpaper> hits;
  final int total;


  WallpaperModal({this.totalHits, this.hits, this.total});

  factory WallpaperModal.fromJson(Map<String, dynamic> json) {

    List<Wallpaper> listWallpaper = List();

    for(Map<String,dynamic> jsonWallpaper in json['hits']){
      listWallpaper.add(Wallpaper.fromJson(jsonWallpaper));
    }

    return WallpaperModal(
        totalHits: json['totalHits'],
        hits: listWallpaper,
        total: json['total']
    );
  }
}
