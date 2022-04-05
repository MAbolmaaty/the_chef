import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:the_chef/models/app_state_manager.dart';
import 'package:the_chef/models/fooderlich_pages.dart';

class OnboardingScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: FooderlichPages.onboardingPath,
        key: ValueKey(FooderlichPages.onboardingPath),
        child: const OnboardingScreen());
  }

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   title: const Text('Getting Started'),
      //   leading: GestureDetector(
      //     child: const Icon(
      //       Icons.chevron_left,
      //       size: 35,
      //     ),
      //     onTap: () {
      //       Navigator.pop(context, true);
      //     },
      //   ),
      // ),
      body: Stack(
        children: [
          buildPages(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: buildIndicator(),
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: buildActionButtons(),
              )),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
            highlightColor: Colors.transparent,
            child: Text(
              'Skip',
              style: GoogleFonts.italiana(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .completeOnboarding();
            }),
      ],
    );
  }

  Widget buildPages() {
    return PageView(
      controller: controller,
      children: [
        onboardPageView(
          const AssetImage('assets/magazine_pics/card_bread.jpg'),
          '''Check out weekly recommended recipes and what your friends are cooking!''',
        ),
        onboardPageView(
          const AssetImage('assets/magazine_pics/card_carrot.png'),
          'Cook with step by step instructions!',
        ),
        onboardPageView(
          const AssetImage('assets/magazine_pics/card_salad.png'),
          'Keep track of what you need to buy',
        ),
      ],
    );
  }

  Widget onboardPageView(ImageProvider imageProvider, String text) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Text(
              text,
              style: GoogleFonts.italiana(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator() {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: const WormEffect(
        activeDotColor: Color(0xffE3E3E6),
        dotHeight: 8,
        dotWidth: 10,
      ),
    );
  }
}
