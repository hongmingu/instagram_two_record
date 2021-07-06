import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';

class UserModelState extends ChangeNotifier{
  UserModel? _userModel;

  StreamSubscription<UserModel>? _currentStreamSub;

  UserModel? get userModel => _userModel;

  set setUserModel(UserModel? userModel){
    _userModel = userModel;
    notifyListeners();
  }

  set setCurrentStreamSub(StreamSubscription<UserModel>? currentStreamSub) {
    if(currentStreamSub != null){
      print("warnign");
    }else{
      print("warnignull");

    }
    _currentStreamSub = currentStreamSub;
  }

  StreamSubscription<UserModel>? get streamSub => _currentStreamSub;

  void clear() async{
    print("here1");
    if(_currentStreamSub != null){
      print("here2");
      await _currentStreamSub!.cancel();
      print("here222");

      _currentStreamSub = null;
      _userModel =null;
    }
  }

  bool amIFollowingThisUser(String otherUserKey){
    if(_userModel == null){
      return false;
    }
    return _userModel!.followings.contains(otherUserKey);
  }

}