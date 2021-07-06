import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/constants/common_size.dart';
import 'package:instagram_two_record/constants/screen_size.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/screens/profile_screen.dart';
import 'package:instagram_two_record/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  ProfileBody({Key? key, required this.onMenuChanged}) : super(key: key);

  final Function onMenuChanged;

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> with SingleTickerProviderStateMixin {
  bool selectedLeft = true;
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size.width;

  late AnimationController _iconAnimationController;


  @override
  void initState() {
    _iconAnimationController = AnimationController(vsync: this, duration: duration);
    super.initState();
    
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appbar(),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: RoundedAvatar(
                            size: 100,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: common_gap),
                            child: Table(
                              children: [
                                TableRow(
                                  children: <Widget>[
                                    _valueText("123123"),
                                    _valueText("1231232"),
                                    _valueText("1231232"),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    _labelText("Post"),
                                    _labelText("Followers"),
                                    _labelText("Following"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    _username(context),
                    _userBio(),
                    _editProfileBtn(),
                    _tabButtons(),
                    _selectedIndicator(),
                  ]),
                ),
                _imagesPager()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 44,
        ),
        Expanded(
            child: Text(
          "The Coding Papa",
          textAlign: TextAlign.center,
        )),
        IconButton(
            onPressed: () {
              widget.onMenuChanged();
              _iconAnimationController.status == AnimationStatus.completed ? _iconAnimationController.reverse() : _iconAnimationController.forward();
            },
            icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _iconAnimationController,))
      ],
    );
  }

  Text _valueText(String value) {
    return Text(
      value,
      style: TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Text _labelText(String value) {
    return Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 11,
      ),
      textAlign: TextAlign.center,
    );
  }

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
        child: Stack(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: duration,
          transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
          child: _images(),
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: duration,
          transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
          child: _images(),
        ),
      ],
    ));
  }

  GridView _images() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: "https://picsum.photos/id/$index/100/100")),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  Row _tabButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
              onPressed: () {
                _tabSelected(SelectedTab.left);
              },
              icon: ImageIcon(
                AssetImage("assets/images/grid.png"),
                color: _selectedTab == SelectedTab.left
                    ? Colors.black
                    : Colors.black26,
              )),
        ),
        Expanded(
          child: IconButton(
              onPressed: () {
                _tabSelected(SelectedTab.right);
              },
              icon: ImageIcon(
                AssetImage("assets/images/saved.png"),
                color: _selectedTab == SelectedTab.left
                    ? Colors.black26
                    : Colors.black,
              )),
        )
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: () {},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username(BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        (userModelState.userModel == null || userModelState == null)?
        "" : Provider.of<UserModelState>(context).userModel!.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        "this is what I believe!",
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}

enum SelectedTab { left, right }
