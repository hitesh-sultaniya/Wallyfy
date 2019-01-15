

class Wallpaper {
  final String largeImageURL;
  final int webformatHeight;
  final int webformatWidth;
  final int likes;
  final int imageWidth;
  final int id;
  final int user_id;
  final String imageURL;
  final int views;
  final int comments;
  final String pageURL;
  final int imageHeight;
  final String webformatURL;
  final String id_hash;
  final String type;
  final int previewHeight;
  final List tags;
  final int downloads;
  final String user;
  final int favorites;
  final int imageSize;
  final int previewWidth;
  final String userImageURL;
  final String fullHDURL;
  final String previewURL;

  Wallpaper({this.largeImageURL, this.webformatHeight, this.webformatWidth, this.likes,this.imageWidth,this.id,this.user_id,this.imageURL,this.views,this.comments,this.pageURL,this.imageHeight,this.webformatURL,this.id_hash,this.type,this.previewHeight,this.tags,this.downloads,this.user,this.favorites,this.imageSize,this.previewWidth,this.userImageURL,this.fullHDURL,this.previewURL});

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      largeImageURL:json['largeImageURL'],
      webformatHeight:json['webformatHeight'],
      webformatWidth:json['webformatWidth'],
      likes:json['likes'],
      imageWidth:json['imageWidth'],
      id:json['id'],
      user_id:json['user_id'],
      imageURL:json['imageURL'],
      views:json['views'],
      comments:json['comments'],
      pageURL:json['pageURL'],
      imageHeight:json['imageHeight'],
      webformatURL:json['webformatURL'],
      id_hash:json['id_hash'],
      type:json['type'],
      previewHeight:json['previewHeight'],
      tags:json['tags'].split(','),
      downloads:json['downloads'],
      user:json['user'],
      favorites:json['favorites'],
      imageSize:json['imageSize'],
      previewWidth:json['previewWidth'],
      userImageURL:json['userImageURL'],
      fullHDURL:json['fullHDURL'],
      previewURL:json['previewURL'],
    );
  }
}