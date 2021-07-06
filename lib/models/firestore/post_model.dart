import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_two_record/constants/firestore_keys.dart';

class PostModel {
  late final String postKey;
  late final String userKey;
  late final String username;
  late final String postImg;
  late final List<dynamic> numOfLikes;
  late final String caption;
  late final String lastCommentor;
  late final String lastComment;
  late final DateTime lastCommentTime;
  late final int numOfComments;
  late final DateTime postTime;
  final DocumentReference? reference;

  //https://github.com/FirebaseExtended/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore/example/lib/movie.dart
  PostModel.fromJson(Map<String, dynamic> json, this.postKey, {this.reference})
      : userKey = json[KEY_USERKEY],
        username = json[KEY_USERNAME],
        postImg = json[KEY_POSTIMG],
        numOfLikes = json[KEY_NUMOFLIKES],
        caption = json[KEY_CAPTION],
        lastCommentor = json[KEY_LASTCOMMENTOR],
        lastComment = json[KEY_LASTCOMMENT],
        lastCommentTime = json[KEY_LASTCOMMENTTIME] == null
            ? DateTime.now().toUtc()
            : (json[KEY_LASTCOMMENTTIME] as Timestamp).toDate(),
        numOfComments = json[KEY_NUMOFCOMMENTS],
        postTime = json[KEY_POSTTIME] == null
            ? DateTime.now().toUtc()
            : (json[KEY_POSTTIME] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      KEY_USERKEY: userKey,
      KEY_USERNAME: username,
      KEY_POSTIMG: postImg,
      KEY_NUMOFLIKES: numOfLikes,
      KEY_CAPTION: caption,
      KEY_LASTCOMMENTOR: lastCommentor,
      KEY_LASTCOMMENT: lastComment,
      KEY_LASTCOMMENTTIME: lastCommentTime,
      KEY_NUMOFCOMMENTS: numOfComments,
      KEY_POSTTIME: postTime,
    };
  }

  PostModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id,
            reference: snapshot.reference);

  static Map<String, dynamic> getMapForCreatePost(
      {required String userKey,
      required String username,
      required String caption}) {
    Map<String, dynamic> map = Map();
    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_POSTIMG] = "";
    map[KEY_NUMOFLIKES] = 0;
    map[KEY_CAPTION] = caption;
    map[KEY_LASTCOMMENTOR] = "";
    map[KEY_LASTCOMMENT] = "";
    map[KEY_LASTCOMMENTTIME] = DateTime.now();
    map[KEY_NUMOFCOMMENTS] = "";
    map[KEY_POSTTIME] = DateTime.now();
    return map;
  }
}
