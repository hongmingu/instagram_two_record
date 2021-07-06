import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:instagram_two_record/constants/common_size.dart';
import 'package:instagram_two_record/constants/screen_size.dart';
import 'package:instagram_two_record/models/firestore/post_model.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/image_network_repository.dart';
import 'package:instagram_two_record/repo/post_network_repository.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

class SharePostScreen extends StatefulWidget {
  SharePostScreen(this.imageFile, {Key? key, required this.postKey})
      : super(key: key);

  final File imageFile;
  final String postKey;

  @override
  _SharePostScreenState createState() => _SharePostScreenState();
}

class _SharePostScreenState extends State<SharePostScreen> {
  TextEditingController _textEditingController = TextEditingController();

  List<String> _tagItem = [
    "hi",
    "hi2",
    "hi3",
    "hi4",
    "hi5",
    "hi6",
    "hi7",
    "hi8",
    "hi822313",
    "hi8123",
    "hi1118",
    "hi2228",
  ];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: sharePostProcedure,
            child: Text(
              "Share",
              textScaleFactor: 1.4,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _captionWithImage(),
          _divider,
          _sectionButton("Tag people"),
          _divider,
          _sectionButton("add Location"),
          _tags(),
          SizedBox(
            height: common_gap,
          ),
          _divider,
          SectionSwitch("Facebook"),
          SectionSwitch("Instagram"),
          SectionSwitch("Tumblr"),
          _divider,
        ],
      ),
    );
  }

  void sharePostProcedure() async {
    showModalBottomSheet(
      context: context,
      builder: (_) =>
          MyProgressIndicator(progressSize: 360, containerSize: 360),
      isDismissible: false,
      enableDrag: false,
    );
    await imageNetworkRepository.uploadImageCreateNewPost(
        widget.imageFile,
        postKey: widget.postKey);

    UserModel? userModel =
        Provider.of<UserModelState>(context, listen: false).userModel;
    await postNetworkRepository.createNewPost(
        widget.postKey,
        PostModel.getMapForCreatePost(
            userKey: userModel!.userKey,
            username: userModel.username,
            caption: _textEditingController.text));

    String postImgLink =
    await imageNetworkRepository.getPostImageUrl(widget.postKey);

    await postNetworkRepository.updatePostImageUrl(
        postImg: postImgLink, postKey: widget.postKey);
    Navigator.of(context).pop(); // 이게 ModelBottomSheet를 사라지게 한다.
    Navigator.of(context).pop(); // 이게 이 화면을 사라지게함
  }

  Tags _tags() {
    return Tags(
      horizontalScroll: true,
      itemCount: _tagItem.length,
      heightHorizontalScroll: 30,
      itemBuilder: (index) => ItemTags(
        title: _tagItem[index],
        index: index,
        activeColor: Colors.pink[100]!,
        textActiveColor: Colors.blue,
        borderRadius: BorderRadius.circular(3),
        elevation: 2,
        splashColor: Colors.yellowAccent,
        highlightColor: Colors.green,
        color: Colors.purple,
      ),
    );
  }

  Divider get _divider => Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 1,
      );

  ListTile _sectionButton(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: Icon(Icons.navigate_next),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: common_gap),
    );
  }

  ListTile _captionWithImage() {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(vertical: common_gap, horizontal: common_gap),
      leading: Image.file(
        widget.imageFile,
        width: size.width / 6,
        height: size.width / 6,
        fit: BoxFit.cover,
      ),
      title: TextField(
        controller: _textEditingController,
        autofocus: true,
        decoration: InputDecoration(
            hintText: "Write a caption", border: InputBorder.none),
      ),
    );
  }
}

class SectionSwitch extends StatefulWidget {
  final String _title;

  const SectionSwitch(
    this._title, {
    Key? key,
  }) : super(key: key);

  @override
  _SectionSwitchState createState() => _SectionSwitchState();
}

class _SectionSwitchState extends State<SectionSwitch> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget._title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: CupertinoSwitch(
        onChanged: (bool value) {
          setState(() {
            checked = value;
          });
        },
        value: checked,
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: common_gap),
    );
  }
}
