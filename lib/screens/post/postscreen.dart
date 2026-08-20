import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/services/firestore_service.dart';

class Postscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PostscreenState();



}
class PostscreenState extends State<Postscreen> {

TextEditingController caption=TextEditingController();



  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No image selected');
  }


  showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ), // SnackBar
    );
  }







Uint8List? file;
  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? pickedfile = await pickImage(ImageSource.camera);
                setState(() {
                  file=pickedfile;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text("Choose from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? pickedfile = await pickImage(ImageSource.gallery);
                setState(() {
                  file=pickedfile;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


final FirestoreService _firestoreService = FirestoreService();
bool isPosting = false;

postImage() async {
  if (file == null) {
    showSnackBar("Pehle image select karo", context);
    return;
  }

  setState(() {
    isPosting = true;
  });

  String result = await _firestoreService.createPost(
    file!,
    caption.text,
  );

  setState(() {
    isPosting = false;
  });

  if (result == "success") {
    showSnackBar("Post ho gayi!", context);
    Get.back();
  } else {
    showSnackBar(result, context);
  }
}

@override
void dispose() {
  caption.dispose();
  super.dispose();
}





// @override
// void dispose() {
//   super.dispose();
//   caption.dispose();  // controller ki memory saaf kar do
// }



  @override
  Widget build(BuildContext context) {
    return file==null? Center(
      child: Container(
        padding: EdgeInsets.all(2), // ye border ki "thickness" hai
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          height: 100,
          width: 100,

          decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Color(0xff4b5459)
              color: Colors.black87
          ),
          child: GestureDetector(
            onTap: ()=>selectImage(context),
            child: Icon(Icons.upload,color: Colors.white,),
          ),

        ),
      ),
    )
    : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: (){Get.back();},
          child: Icon(Icons.arrow_back,color: Colors.white,),

        ),
        title: Text("Post To",style: TextStyle(color: Colors.white),),
        actions: [
          Padding(
             padding: EdgeInsetsGeometry.only(right: 20),
            child: GestureDetector(
              onTap: ()=>postImage(),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Colors.green, Colors.blue], //
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);

                },child: isPosting?
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.purple),

                  )
                  :Text('Post',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),)

              ),
            ),
          )
        ],
      ),
      body:Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(2), // ye border ki "thickness" hai
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width*0.35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black87
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: Image.memory(file!,fit: BoxFit.fitWidth,)),
                ),
              ),
              SizedBox(
                height: 40,
              ),

              Container(
                padding: EdgeInsets.all(2), // ye border ki "thickness" hai
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black87
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: TextField(
                      controller:caption ,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Write a Caption...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none
                      ),
                      maxLines: 8,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )

    );
  }
}




// Text("Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),