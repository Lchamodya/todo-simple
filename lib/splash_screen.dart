import 'package:flutter/material.dart';
import 'components/widgets.dart';
import 'routes/pages.dart';
import 'utils/color_palette.dart';
import 'utils/font_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Pages.home,
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 100,
            ),
            const SizedBox(height: 20),
            _buildSplashText(
              text: 'Just Don\'t Forget,',
              color: kWhiteColor,
              fontSize: fontSizeBold,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),
            _buildSplashText(
              text: 'We\'ve Got You Covered!',
              color: kWhiteColor,
              fontSize: fontSizeTiny,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashText({
    required String text,
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
    );
  }
}
