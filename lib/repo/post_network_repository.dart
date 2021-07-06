import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_two_record/constants/firestore_keys.dart';

class PostNetworkRepository {
  Future<Map<String, dynamic>?> createNewPost(
    String postKey,
    Map<String, dynamic> postData,
  ) async {
    //없으면 생성된다.
    final DocumentReference postRef =
        FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();

    final DocumentReference userRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(postData[KEY_USERKEY]);

    return FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      //제대로 안되면 다 원상복구
      if (!postSnapshot.exists) {
        await transaction.set(postRef, postData);
        await transaction.update(userRef, {
          KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
        });
      }
    });
  }

  Future<void> updatePostImageUrl({required String postImg, required String postKey}) async{

    final DocumentReference postRef =
    FirebaseFirestore.instance.collection(COLLECTION_POSTS).doc(postKey);

    final DocumentSnapshot postSnapshot = await postRef.get();

    if(postSnapshot.exists){
      await postRef.update({KEY_POSTIMG:postImg});
    }
  }
}

PostNetworkRepository postNetworkRepository = PostNetworkRepository();
