import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/constants/common_size.dart';
import 'package:instagram_two_record/constants/screen_size.dart';
import 'package:instagram_two_record/repo/image_network_repository.dart';
import 'package:instagram_two_record/widgets/comment.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:instagram_two_record/widgets/rounded_avatar.dart';

class Post extends StatelessWidget {
  final int number;
  late double sizeWidth;
  late double sizeHeight;

  Post(
    this.number, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postHeader(),
        _postImage(),
        _postActions(),
        _postLikes(),
        _postCaption()
      ],
    );
  }

  Widget _postCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_gap),
      child: Comment(
        showImage: false,
        username: "username123",
        text: "hello www",
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        "12000 likes",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions() {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: null,
          icon: ImageIcon(AssetImage("assets/images/bookmark.png")),
          color: Colors.black,
        ),
        IconButton(
          onPressed: null,
          icon: ImageIcon(AssetImage("assets/images/comment.png")),
          color: Colors.black,
        ),
        IconButton(
          onPressed: null,
          icon: ImageIcon(AssetImage("assets/images/direct_message.png")),
          color: Colors.black,
        ),
        Spacer(),
        IconButton(
          onPressed: null,
          icon: ImageIcon(AssetImage("assets/images/heart_selected.png")),
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _postHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text("username")),
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black87,
            ))
      ],
    );
  }

  dynamic _postImage() {
    Widget progress = MyProgressIndicator(
        progressSize: size.width, containerSize: common_gap);
    return FutureBuilder<dynamic>(
      future: imageNetworkRepository
          .getPostImageUrl("1624955124408_H9QMvraLgVN9bkSDSPtQWjkjTsk1"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CachedNetworkImage(
            imageUrl: snapshot.data as String,
            placeholder: (BuildContext context, String url) {
              return progress;
            },
            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
              return AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  ));
            },
          );
        } else {
          return progress;
        }
      },
    );
  }
}
