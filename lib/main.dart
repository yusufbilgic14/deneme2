import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userme/pages/auth/login.dart';

import 'package:userme/pages/tabs/tabs_page.dart';
import 'package:userme/provider/appstate.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const UsermeApp());
}

class UsermeApp extends StatelessWidget {
  const UsermeApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider( providers:  [
      ChangeNotifierProvider(create: (context) => AppState(),)
    ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white,),
            useMaterial3: true,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container( );
                
              }
              if (snapshot.hasData) {
                return const TabsPage();
                
              }
              return const Login();
            }
          ),
        );
      }
    );
  }
}
