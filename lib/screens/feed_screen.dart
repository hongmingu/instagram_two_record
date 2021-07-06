import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/user_network_repository.dart';
import 'package:instagram_two_record/widgets/post.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: IconButton(
          onPressed: null,
          icon: Icon(
            CupertinoIcons.photo_camera_solid,
            color: Colors.black,
          ),
        ),
        middle: Text(
          "Instagram",
          style: TextStyle(fontFamily: "VeganStyle", color: Colors.black87),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                onPressed: (){
                  userNetworkRepository.sendData();
                },
                icon: ImageIcon(
                  AssetImage('assets/images/actionbar_camera.png'),
                  color: Colors.black87,
                )),
            IconButton(
                onPressed: (){

                  userNetworkRepository.getAllUserWithoutMe().listen((event) {
                    print(event);
                  });


                },
                icon: ImageIcon(
                  AssetImage('assets/images/direct_message.png'),
                  color: Colors.black87,
                ))
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: feedListBuilder,
        itemCount: 30,
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, int index) {
    return Post(index);
  }
}
