import 'package:flutter/material.dart';
import 'package:instagram_two_record/constants/screen_size.dart';
import 'package:instagram_two_record/models/firebase_auth_state.dart';
import 'package:instagram_two_record/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class ProfileSideMenu extends StatelessWidget {
  ProfileSideMenu({Key? key, required this.menuWidth}) : super(key: key);
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                "Setting",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black87,
              ),
              title: Text("Sign out"),
              onTap: () {
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   builder: (context) => AuthScreen()
                // ));
              },
            )
          ],
        ),
      ),
    );
  }
}
