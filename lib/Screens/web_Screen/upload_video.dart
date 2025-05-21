import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

final uploadedVideoUrlProvider = StateProvider<List<String>> ((ref)=>[]);
final isUploadingProvider= StateProvider<bool> ((ref)=>false);

class UploadVideoWeb extends ConsumerStatefulWidget {
  const UploadVideoWeb({super.key});

  @override
  ConsumerState<UploadVideoWeb>createState()=> _UploadVideoWebState();
}

class _UploadVideoWebState extends ConsumerState<UploadVideoWeb> {

Future<void> addvideo(String title , String video , String videourl )async{
  await FirebaseFirestore.instance.collection("videos").add({
    "title":title,
    "videourl":videourl,
    "uploaded": FieldValue.serverTimestamp(),
  });
  }


Future<void> _pickAndUploadVideo()async{
   ref.read(isUploadingProvider.notifier).state = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
  if(result != null && result.files.single.bytes != null){
    final fileBytes = result.files.single.bytes!;
    final filename = result.files.single.name;

    //Upload to firebase Storage 

   
    try {
        final refStorage = FirebaseStorage.instance.ref('uploads/$filename');
        await refStorage.putData(
          fileBytes,
          SettableMetadata(contentType: 'video/mp4'),
        );
        final url = await refStorage.getDownloadURL();
        ref.read(uploadedVideoUrlProvider.notifier).state = [
          ...ref.read(uploadedVideoUrlProvider),
          url
        ];
        await addvideo(filename, filename, url);
      } catch (e) {
        // ignore: avoid_print
        print('Upload failed: $e');
        // Optionally show a snackbar or message
      } finally {
        ref.read(isUploadingProvider.notifier).state = false;
      }
    } else {
      ref.read(isUploadingProvider.notifier).state = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    final isUploading = ref.watch(isUploadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload videos"),
        
      ),

      body: Center(child:
          AnimatedSwitcher(
            duration: Duration(microseconds: 300),
            child:isUploading?
             ElevatedButton(
              key: ValueKey("uploading"),
              onPressed:  null , 
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200,50),
              ),
            child: Row(
              mainAxisSize:MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: 1),
                  curve: Curves.linear,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: 2 * pi * value,
                      child:Icon(Icons.refresh,color: Colors.white,),
                    );
                  },
                  onEnd: (){},
                ),
                SizedBox(width: 15,),
                Text("Uploading ..."),
              ],
            ),
            ):ElevatedButton(key: ValueKey("value"), 
            onPressed: _pickAndUploadVideo, 
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200,50)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8,height: 10,), 
                Text("Upload video"),
              ],
            ))
            ),

     
  
      ),
      
      );

  }
}