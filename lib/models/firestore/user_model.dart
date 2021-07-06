import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_two_record/constants/firestore_keys.dart';

class UserModel {
  late final String userKey;
  late final String profileImg;
  late final String email;
  late final List<dynamic> myPosts;
  late final int followers;
  late final List<dynamic> likedPosts;
  late final String username;
  late final List<dynamic> followings;

  final DocumentReference? reference;

  //https://github.com/FirebaseExtended/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore/example/lib/movie.dart
  UserModel.fromMap(Map<String, dynamic> map, this.userKey, {this.reference})
      : profileImg = map[KEY_PROFILEIMG],
        username = map[KEY_USERNAME],
        email = map[KEY_EMAIL],
        likedPosts = map[KEY_LIKEDPOSTS],
        followers = map[KEY_FOLLOWERS],
        followings = map[KEY_FOLLOWINGS],
        myPosts = map[KEY_MYPOSTS];

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, {this.reference})
      : profileImg = json[KEY_PROFILEIMG],
        username = json[KEY_USERNAME],
        email = json[KEY_EMAIL],
        likedPosts = json[KEY_LIKEDPOSTS],
        followers = json[KEY_FOLLOWERS],
        followings = json[KEY_FOLLOWINGS],
        myPosts = json[KEY_MYPOSTS];

  Map<String, dynamic> toJson() {
    return {
      KEY_PROFILEIMG: profileImg,
      KEY_USERNAME: username,
      KEY_EMAIL: email,
      KEY_LIKEDPOSTS: likedPosts,
      KEY_FOLLOWERS: followers,
      KEY_FOLLOWINGS: followings,
      KEY_MYPOSTS: myPosts,
    };
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id,
            reference: snapshot.reference);


  static Map<String, dynamic> getMapForCreateUser(String? email) {
    return {
      KEY_PROFILEIMG: "",
      KEY_USERNAME: email!.split("@")[0],
      KEY_EMAIL: email,
      KEY_LIKEDPOSTS: [],
      KEY_FOLLOWERS: 0,
      KEY_FOLLOWINGS: [],
      KEY_MYPOSTS: [],
    };
  }
}
