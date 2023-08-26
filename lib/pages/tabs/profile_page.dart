import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userme/pages/profile/update_profile.dart';
import 'package:userme/provider/appstate.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 10, 90),
        title: const Text("Profile",
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      floatingActionButton: TextButton(
          onPressed: () async {
            var app = Provider.of<AppState>(context, listen: false);
            await app.logout(context);
          },
          child: const Text("Logout")),
      body: Consumer<AppState>(builder: (context, app, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if( app.user!.profileImageUrl != null &&  app.user!.profileImageUrl!.isNotEmpty )...[
                  ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:   Image.network(app.user!.profileImageUrl!, height: 100, width: 100,fit: BoxFit.cover,),
            ),
            const SizedBox(height: 8,),
            TextButton(onPressed: () async {
              await app.removeProfileImage(context);
            }, child: const Text("Remove Photo")),
            const SizedBox(height: 16)
                ],
                Text(" ${app.user!.fullName}"),
                const SizedBox(height: 4,),
                 Text(" ${app.user!.email}"),
                const SizedBox(
                  height: 4,
                ),
                 Text("${app.user!.bio}"),
                const SizedBox(
                  height: 4,
                ),

                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>const UpdateProfile()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Update User Info"),
                        Icon(Icons.arrow_right_alt)
                      ],
                    )),
              ],
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
    );
  }
}
