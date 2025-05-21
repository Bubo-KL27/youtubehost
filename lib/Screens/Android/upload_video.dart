// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

// Providers
final videoFileProvider = StateProvider<List<File>>((ref) => []);
final videoPlayerControllerProvider = StateProvider<List<VideoPlayerController>>((ref) => []);
final uploadedVideoUrlProvider = StateProvider<List<String>>((ref) => []);
final isUploadingProvider = StateProvider<bool>((ref) => false);

class Addbuttonscreen extends ConsumerStatefulWidget {
  const Addbuttonscreen({super.key});
  @override
  ConsumerState<Addbuttonscreen> createState() => _AddbuttonscreenState();
}

class _AddbuttonscreenState extends ConsumerState<Addbuttonscreen> {
  Future<void> _pickVideoFromGallery() async {
    ref.read(isUploadingProvider.notifier).state = true;
    try {
      final pickfile = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );
      if (pickfile != null && pickfile.files.isNotEmpty) {
        final files = pickfile.paths.whereType<String>().map((path) => File(path)).toList();
        final controller = <VideoPlayerController>[];
        final url = <String>[];

        for (var file in files) {
          try {
            final videoController = VideoPlayerController.file(file);
            await videoController.initialize();
            controller.add(videoController);

            final filename = file.path.split('/').last;
            final refStorage = FirebaseStorage.instance.ref('uploads/$filename');
            await refStorage.putFile(file);
            final downloadurl = await refStorage.getDownloadURL();
            url.add(downloadurl);
          } catch (e) {
            print("Error uploading file ${file.path}: $e");
          }
        }

        ref.read(videoFileProvider.notifier).state = files;
        ref.read(videoPlayerControllerProvider.notifier).state = controller;
        ref.read(uploadedVideoUrlProvider.notifier).state = [
          ...ref.read(uploadedVideoUrlProvider),
          ...url
        ];
      }
    } catch (e) {
      print("Gallery upload error: $e");
    } finally {
      ref.read(isUploadingProvider.notifier).state = false;
    }
  }

  Future<void> _takevideofromcamera() async {
    ref.read(isUploadingProvider.notifier).state = true;
    try {
      final url = <String>[];
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final videocontroller = VideoPlayerController.file(file);
        await videocontroller.initialize();

        final files = [...ref.read(videoFileProvider)];
        final controllers = [...ref.read(videoPlayerControllerProvider)];
        files.add(file);
        controllers.add(videocontroller);

        ref.read(videoFileProvider.notifier).state = files;
        ref.read(videoPlayerControllerProvider.notifier).state = controllers;

        final filename = file.path.split('/').last;
        final refStorage = FirebaseStorage.instance.ref('uploads/$filename');
        await refStorage.putFile(file);
        final downloadurl = await refStorage.getDownloadURL();
        url.add(downloadurl);

        ref.read(uploadedVideoUrlProvider.notifier).state = [
          ...ref.read(uploadedVideoUrlProvider),
          ...url
        ];
      }
    } catch (e) {
      print("camera upload error: $e");
    } finally {
      ref.read(isUploadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadedUrls = ref.watch(uploadedVideoUrlProvider);
    final _isUploading = ref.watch(isUploadingProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : _pickVideoFromGallery,
              child: Text(_isUploading ? "Uploading..." : "upload Video"),
            ),
            ElevatedButton(
              onPressed: _isUploading ? null : _takevideofromcamera,
              child: Text(_isUploading ? "Uploading..." : "take Video"),
            ),
            if (uploadedUrls.isNotEmpty) ...[
              Text("Video uploaded")
            ]
          ],
        ),
      ),
    );
  }
}