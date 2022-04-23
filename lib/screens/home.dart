import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_chef/models/fooderlich_pages.dart';
import 'package:the_chef/models/models.dart';
import 'package:the_chef/models/profile_manager.dart';
import 'package:the_chef/screens/explore_screen.dart';
import 'package:the_chef/screens/grocery_screen.dart';
import 'package:the_chef/screens/recipes_screen.dart';

// 1
class Home extends StatefulWidget {
  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: FooderlichPages.home,
      key: ValueKey(FooderlichPages.home),
      child: Home(
        currentTab: currentTab,
      ),
    );
  }

  const Home({Key? key, required this.currentTab}) : super(key: key);

  final int currentTab;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //int _selectedIndex = 0;

  List<Widget> pageList = <Widget>[];

  static const String prefSelectedIndexKey = 'selectedIndex';

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    pageList.add(ExploreScreen());
    pageList.add(RecipesScreen());
    pageList.add(const GroceryScreen());
    getCurrentIndex();
  }

  void saveCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefSelectedIndexKey,
        Provider.of<AppStateManager>(context, listen: false).getSelectedTab);
  }

  void getCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(prefSelectedIndexKey)) {
      setState(() {
        final index = prefs.getInt(prefSelectedIndexKey);
        if (index != null) {
          Provider.of<AppStateManager>(context, listen: false).goToTab(index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
        builder: (context, appStateManager, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'The Chef',
            style: GoogleFonts.diplomata(
                color: const Color(0xff900B0B), fontWeight: FontWeight.bold),
          ),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       final manager =
            //           Provider.of<SearchRecipesManager>(context, listen: false);
            //       manager.tapOnSearch(true);
            //     },
            //     icon: const Icon(Icons.search)),
            //profileButton(),
          ],
        ),
        body: IndexedStack(
          index: widget.currentTab,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              Theme.of(context).textSelectionTheme.selectionColor,
          currentIndex: widget.currentTab,
          onTap: (index) {
            Provider.of<AppStateManager>(context, listen: false).goToTab(index);
            saveCurrentIndex();
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Recipes'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To Buy'),
          ],
        ),
      );
    });
  }

  Widget profileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: const CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/profile_pics/person_stef.jpeg'),
        ),
        onTap: () {
          Provider.of<ProfileManager>(context, listen: false)
              .tapOnProfile(true);
        },
      ),
    );
  }
}
