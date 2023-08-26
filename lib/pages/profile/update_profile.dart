import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:userme/provider/appstate.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
    File? pickedFile;
   final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController usernameCtr = TextEditingController();
  TextEditingController bioCtr = TextEditingController();
  @override
  void initState() {
    fillFromUser();
    super.initState();
    
  }
  fillFromUser(){
    var app=Provider.of<AppState>(context, listen: false);
    usernameCtr.text=app.user!.fullName;
    bioCtr.text = app.user!.bio?? "";
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile "),
        centerTitle: true,
        
      ),
                 
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
          onPressed: () async {
            var appState = Provider.of<AppState>(context, listen: false);
                      if(pickedFile!= null){
                        await appState.uploadProfileImage(pickedFile!);
            
          }
            final isvalid = formKey.currentState!.validate();
            if (isvalid) {
              
              var user=appState.user;
              user=user!.copyWith(bio: bioCtr.text, fullName: usernameCtr.text);
              await appState.updateUser(user, context);
             
            
          }
},
          child: const Text("Update")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                if(pickedFile == null)
                IconButton.filled(
              iconSize: 76,
              icon: const Icon(Icons.photo_camera),
              style: IconButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 99, 10, 90)),
              onPressed: () async {
                var source = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Select Source",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    content: const Text(
                      "Please Select Any Source",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, ImageSource.camera),
                        child: const Text(
                          "Camera",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, ImageSource.gallery),
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      )
                    ],
                  ),
                );
                if (source != null) {
                  await pickImage(source);
                }
              },
            ),
                      if (pickedFile != null) ...[
          
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:   Image.file(pickedFile!, height: 100, width: 100,fit: BoxFit.cover,),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  pickedFile = null;
                });
              },
              child: const Text(
                "Remove Photo",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            )
          ],
                TextFormField(
                  controller: usernameCtr,
                  validator: (value) {
                    if (value != null && value.length >= 3) {
                      return null;
                    }
                    return "Bu alan boş bırakılamaz.";
                  },
                  decoration: const InputDecoration(
                    //suffixIcon: Icon(CupertinoIcons.info_circle),
                    hintText: "İsim-Soyisim",
                    labelText: "İsim-Soyisim",
                  ),
                ),
                TextFormField(
                  controller: bioCtr,
                  validator: (value) {
                   return null;
                  },
                  decoration: const InputDecoration(
                    //suffixIcon: Icon(CupertinoIcons.info_circle),
                    hintText: "Bio",
                    labelText: "Bio",
                  ),
                ),
               ],
            ),
          ),
        ),
      ),
      
  
    );
  }
    Future<void> pickImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        pickedFile = File(image.path);
      });
    }
  }
}