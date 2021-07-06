import 'package:flutter/material.dart';
import 'package:instagram_two_record/screens/profile_screen.dart';
import 'package:instagram_two_record/widgets/sign_in_form.dart';
import 'package:instagram_two_record/widgets/sign_up_form.dart';

class FadeStack extends StatefulWidget {
  final int selectedForm;
  const FadeStack({Key? key, required this.selectedForm}) : super(key: key);

  @override
  _FadeStackState createState() => _FadeStackState();
}

class _FadeStackState extends State<FadeStack>
    with SingleTickerProviderStateMixin {

  List<Widget> forms = [SignUpForm(), SignInForm()];
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(FadeStack oldWidget) {
    if (widget.selectedForm != oldWidget.selectedForm){
      _animationController.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return
      FadeTransition(
        opacity: _animationController,
        child: IndexedStack(
          index: widget.selectedForm,
          children: forms,
        ),
      );
  }
}
