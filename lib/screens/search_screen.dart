import 'package:flutter/material.dart';
import 'package:instagram_two_record/constants/common_size.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/user_network_repository.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:instagram_two_record/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Follow/UnFollow"),
      ),
      body: StreamBuilder(
        stream: userNetworkRepository.getAllUserWithoutMe(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
                child: Consumer<UserModelState>(
                  builder: (BuildContext context, value, Widget? child) {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          UserModel otherUser = snapshot.data[index];

                          UserModelState myUserModelState = value;
                          bool amIFollowing = myUserModelState
                              .amIFollowingThisUser(otherUser.userKey);
                          return ListTile(
                            onTap: () {
                              setState(() {
                                amIFollowing ?
                                userNetworkRepository
                                    .unFollowUser(
                                    myUserKey: value.userModel!.userKey,
                                    otherUserKey: otherUser.userKey) :
                                userNetworkRepository
                                    .followUser(
                                    myUserKey: value.userModel!.userKey,
                                    otherUserKey: otherUser.userKey);
                                // followings[index] = !followings[index];
                              });
                            },
                            leading: RoundedAvatar(),
                            title: Text("username ${otherUser.username}"),
                            subtitle: Text(
                                "user bio number ${otherUser.username}"),
                            trailing: Container(
                              height: 30,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                border: Border.all(
                                    color: Colors.red, width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FittedBox(
                                child: Text(
                                  amIFollowing ? "unfollow" : "follow",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.grey);
                        },
                        itemCount: snapshot.data.length);
                  },
                ));
          } else {
            return MyProgressIndicator(progressSize: 360, containerSize: 360);
          }
        },
      ),
    );
  }
}
