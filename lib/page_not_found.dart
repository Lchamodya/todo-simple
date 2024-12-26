import 'package:flutter/material.dart';
import 'utils/color_palette.dart';
import 'utils/font_sizes.dart';
import 'package:todo_simple/routes/pages.dart';


class PageNotFound extends StatelessWidget {
  final String errorMessage;

  const PageNotFound({Key? key, this.errorMessage = 'Page not found'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(
                color: kBlackColor,
                fontSize: fontSizeBold,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Oops! Something went wrong.',
              style: TextStyle(
                color: kBlackColor,
                fontSize: fontSizeSmall,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Pages.home, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
              ),
              child: const Text(
                'Go to Home',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
