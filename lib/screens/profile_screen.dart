import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_chef/circle_image.dart';
import 'package:the_chef/models/fooderlich_pages.dart';
import 'package:the_chef/models/models.dart';
import 'package:the_chef/models/profile_manager.dart';
import 'package:the_chef/models/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static MaterialPage page(User user) {
    return MaterialPage(
        name: FooderlichPages.profilePath,
        key: ValueKey(FooderlichPages.profilePath),
        child: ProfileScreen(user: user));
  }

  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Provider.of<ProfileManager>(context, listen: false)
                  .tapOnProfile(false);
            },
            icon: const Icon(Icons.close)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16.0,
            ),
            buildProfile(),
            Expanded(child: buildMenu()),
          ],
        ),
      ),
    );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        buildDarkModeRow(),
        ListTile(
          title: const Text('View raywenderlich.com'),
          onTap: () async {
            if (kIsWeb) {
              await launch('https://www.raywenderlich.com/');
            } else {
              Provider.of<ProfileManager>(context, listen: false)
                  .tapOnRaywenderlich(true);
            }
          },
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () {
            Provider.of<ProfileManager>(context, listen: false)
                .tapOnProfile(false);
            Provider.of<AppStateManager>(context, listen: false).logout();
          },
        ),
      ],
    );
  }

  Widget buildDarkModeRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dark Mode'),
          Switch(
              value: widget.user.darkMode,
              onChanged: (value) {
                Provider.of<ProfileManager>(context, listen: false).darkMode =
                    value;
              })
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleImage(
          imageProvider: AssetImage(widget.user.profileImageUrl),
          imageRadius: 60.0,
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          widget.user.firstName,
          style: const TextStyle(fontSize: 21),
        ),
        Text(widget.user.role),
        Text(
          '${widget.user.points} points',
          style: TextStyle(fontSize: 30, color: Colors.green),
        ),
      ],
    );
  }
}
