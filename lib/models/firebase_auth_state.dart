import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:instagram_two_record/repo/user_network_repository.dart';
import 'package:instagram_two_record/utils/simple_snackbar.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progress;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  User? _firebaseUser;


  void watchAuthChange() {
    print("HereCalled");
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null && _firebaseUser == null) {
        changeFirebaseAuthStatus();
        return;
      } else if (firebaseUser != _firebaseUser) {
        //다름
        _firebaseUser = firebaseUser;
        changeFirebaseAuthStatus();
      }
    });
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus? firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseUser != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    notifyListeners();
  }

  void login(BuildContext context,
      {required String email, required String password}) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    late UserCredential credential;
    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException catch (error) {
      String _message = "";
      switch (error.code) {
        case "invalid-email":
          _message = "잘못된 이메일";
          break;
        case "user-disabled":
          _message = "비활성화된 유저";
          break;
        case "user-not-found":
          _message = "유저못찾음";
          break;
        case "wrong-password":
          _message = "잘못된 비번";
          break;
      }
      SnackBar snackBar = SnackBar(content: Text(_message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    _firebaseUser = credential.user;
    if (_firebaseUser == null) {
      simpleSnackBar(context, "Please try again later");
    }
    // error 핸들링은 따로 해줘야 할 것이다.
  }

  void registerUser(BuildContext context,
      {required String email, required String password}) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email.trim(), password: password)
        .catchError((error) {
      print(error);
      String _message = "";
      switch (error.code) {
        case "email-already-in-use":
          _message = "이메일이 이미 사용중입니다.";
          break;
        case "invalid-email":
          _message = "유효한 이메일이 아닙니다.";
          break;
        case "operation-not-allowed":
          _message = "허용되지 않은 접근입니다.";
          break;
        case "weak-password":
          _message = "비밀번호 규칙이 약합니다.";
          break;
      }
      SnackBar snackBar = SnackBar(content: Text(_message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    _firebaseUser = credential.user;
    if (_firebaseUser == null) {
      simpleSnackBar(context, "Please try again later");
    } else {
      await userNetworkRepository.attemptCreateUser(
          userKey: _firebaseUser?.uid, email: _firebaseUser?.email);
    }

    // error 핸들링은 따로 해줘야 할 것이다.
  }

  void signOut() async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      await _firebaseAuth.signOut();
      if (await _facebookLogin.isLoggedIn) {
        _facebookLogin.logOut();
      }
    }
    notifyListeners();
  }

  void loginWithFacebook(BuildContext context) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    if (_facebookLogin == null) {
      _facebookLogin = FacebookLogin();
    }
    final result = await _facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _handleFacebookTokenWithFirebase(context, result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        simpleSnackBar(context, "User cancel facebook sign in");
        break;
      case FacebookLoginStatus.error:
        simpleSnackBar(context, "Error while facebook sign in");
        _facebookLogin.logOut();
        break;
    }
  }

  void _handleFacebookTokenWithFirebase(
      BuildContext context, String token) async {
    final AuthCredential credential = FacebookAuthProvider.credential(token);
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;

    _firebaseUser = user;
    if (_firebaseUser == null) {
      simpleSnackBar(context, "페북 로그인이 잘 안됐음");
    } else {
      await userNetworkRepository.attemptCreateUser(
          userKey: _firebaseUser?.uid, email: _firebaseUser?.email);
    }
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;

  User? get firebaseUser => _firebaseUser;
}

enum FirebaseAuthStatus { signout, progress, signin }
