import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/camera_state.dart';
import 'package:instagram_two_record/models/gallery_state.dart';
import 'package:instagram_two_record/screens/profile_screen.dart';
import 'package:instagram_two_record/widgets/my_gallery.dart';
import 'package:instagram_two_record/widgets/take_photo.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key}) : super(key: key);

  CameraState _cameraState = CameraState();
  GalleryState _galleryState = GalleryState();

  @override
  _CameraScreenState createState() {
    _cameraState.getReadyToTakePhoto();
    _galleryState.initProvider();
    return _CameraScreenState();

  }
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 1);
  String title = "PHOTO";

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),
        ChangeNotifierProvider<GalleryState>.value(value: widget._galleryState),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(title),),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            MyGallery(),
            TakePhoto(),
            Container(
              color: Colors.purple,
            ),
          ],
          onPageChanged: _onItemTapped,
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.blue,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: "GALLERY"),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: "PHOTO"),
            BottomNavigationBarItem(
                icon: Icon(Icons.radio_button_checked), label: "MEDIA"),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
        backgroundColor: Colors.cyanAccent,
      ),
    );
  }

  void _onItemTapped(int index) {
    print(index);
    setState(() {
      _currentIndex = index;
      switch(_currentIndex){
        case 0:
          title = "GALLERY";
          break;
        case 1:
          title = "PHOTO";
          break;
        case 2:
          title = "MEDIA";
          break;

      }
      _pageController.animateToPage(_currentIndex, duration: duration, curve: Curves.fastOutSlowIn);
    });
  }
}

