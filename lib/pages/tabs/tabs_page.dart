import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userme/pages/tabs/home_page.dart';
import 'package:userme/pages/tabs/profile_page.dart';
import 'package:userme/provider/appstate.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  var isLoading= false;
  changeIsLoading()=> setState(() =>isLoading= !isLoading );
  var currentTabIndex=0;
  final List<BottomNavigationBarItem> tabs=[const BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
  const BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_alt_circle), label: "Profile")];

  final List<Widget> tabPages =[
    const HomePage(), const ProfilePage()

  ];
  changeTabIndex(int i)=> setState(() => currentTabIndex=i);
  @override
  void initState() {
    // TODO: implement initState
    constructPage();
    super.initState();
  }
  constructPage() async { 
    changeIsLoading();
    var app= Provider.of<AppState>(context, listen: false);
    await app.getUser();
  
   changeIsLoading();}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 99, 10, 90),
      bottomNavigationBar: BottomNavigationBar(items: tabs,
      backgroundColor: const Color.fromARGB(255, 99, 10, 90),
      selectedItemColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      onTap: changeTabIndex ,
      currentIndex: currentTabIndex
      ,),
      body: isLoading? const Center(child: CupertinoActivityIndicator()): tabPages[currentTabIndex],
      
    );
  }
}