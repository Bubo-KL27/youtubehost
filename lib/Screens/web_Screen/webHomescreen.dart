// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube/Screens/web_Screen/login_screen.dart';
import 'package:youtube/Screens/web_Screen/upload_video.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class Youtubewebhomescreen extends ConsumerStatefulWidget {
  const Youtubewebhomescreen({super.key});

  @override
  ConsumerState<Youtubewebhomescreen> createState() =>
      _YoutubewebhomescreenState();
}

class _YoutubewebhomescreenState extends ConsumerState<Youtubewebhomescreen> {
  final List<VideoPlayerController> _controller = [];
  bool _drawerOpen = false;
  bool _showMobileSearch = false;

  @override
  void dispose() {
    for (final controller in _controller) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideo(List<String> url) async {
    for (final controller in _controller) {
      controller.dispose();
    }
    _controller.clear();

    for (final videoUrl in url) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      _controller.add(controller);
    }
    setState(() {});
  }

  Widget _buildTabletLayout() {
    final downloadUrl = ref.watch(uploadedVideoUrlProvider);
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Videos", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          // <-- Add this
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns for tablet
              childAspectRatio: 4 / 5,
            ),
            itemCount: downloadUrl.length,
            itemBuilder: (context, index) {
              final controller =
                  (index < _controller.length) ? _controller[index] : null;
              return _videoCard(controller, 400);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    final downloadUrl = ref.watch(uploadedVideoUrlProvider);
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Videos", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns for desktop
              childAspectRatio: 16 / 13,
            ),
            itemCount: downloadUrl.length,
            itemBuilder: (context, index) {
              final controller =
                  (index < _controller.length) ? _controller[index] : null;
              return _videoCard(controller, 480);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final downloadUrl = ref.watch(uploadedVideoUrlProvider);
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Text("Videos", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          // <-- Add this
          child: ListView.builder(
            itemCount: downloadUrl.length,
            itemBuilder: (context, index) {
              final controller =
                  (index < _controller.length) ? _controller[index] : null;
              return _videoCard(controller, 320); // smaller width for mobile
            },
          ),
        ),
      ],
    );
  }

  Widget _videoCard(VideoPlayerController? controller, double width) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(8),
          child:
              controller != null && controller.value.isInitialized
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: VideoPlayer(controller),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          IconButton(
                            icon: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              setState(() {
                                if (controller.value.isPlaying) {
                                  controller.pause();
                                } else {
                                  controller.play();
                                }
                              });
                            },
                          ),
                          Text(
                            "${controller.value.position.inMinutes.toString().padLeft(2, '0')}:${(controller.value.position.inSeconds % 60).toString().padLeft(2, '0')}/"
                            "${controller.value.duration.inMinutes.toString().padLeft(2, '0')}:${(controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                          ),
                        ],
                      ),
                    ],
                  )
                  : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final showDrawer = width < 1200;
    final downloadUrl = ref.watch(uploadedVideoUrlProvider);
    if (downloadUrl.isNotEmpty &&
        (_controller.length != downloadUrl.length ||
            _controller.isEmpty ||
            !_controller.asMap().entries.every(
              (e) => e.value.dataSource == downloadUrl[e.key],
            ))) {
      _initializeVideo(downloadUrl);
    }

    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,

      //------AppBar
      //-----------------------
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (showDrawer) {
              scaffoldKey.currentState?.openDrawer();
            } else {
              setState(() {
                _drawerOpen = !_drawerOpen;
              });
            }
          },
          icon: Icon(Icons.menu),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            if (_showMobileSearch && isMobile) {
              // Show search bar with mic on mobile
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _showMobileSearch = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                ],
              );
            } else if (isMobile) {
              // Only show search and mic icons on mobile
              return Row(
                children: [
                  Icon(Icons.play_circle, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Youtube",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _showMobileSearch = true;
                      });
                    },
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                ],
              );
            } else {
              // Normal AppBar for tablet/desktop
              return Row(
                children: [
                  Icon(Icons.play_circle, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Youtube",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    width: 300,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                ],
              );
            }
          },
        ),
        actions: [
          if (!(_showMobileSearch &&
              MediaQuery.of(context).size.width < 600)) ...[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadVideoWeb()),
                );
              },
              icon: Text("+ Create", style: TextStyle()),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.access_alarm_sharp)),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreenWeb()),
                  (route) => false,
                );
              },
              icon: CircleAvatar(),
            ),
          ],
        ],
      ),

      //Drawer
      //--------------
      drawer:
          showDrawer
              ? Drawer(
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(children: [Icon(Icons.home), Text("Home")]),
                    ),

                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.video_collection),
                          SizedBox(width: 10),
                          Text("Shorts"),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.video_library),
                          SizedBox(width: 10),
                          Text("Subscription"),
                        ],
                      ),
                    ),

                    Divider(thickness: 2),

                    ElevatedButton(onPressed: () {}, child: Text("You >")),
                  ],
                ),
              )
              : null,

      //----Body-----
      //===============
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          if (width < 600) {
            return _buildMobileLayout();
          } else if (600 <= width && width <= 1200) {
            return _buildTabletLayout();
          } else {
            return Row(
              children: [
                if (!_drawerOpen)
                  Container(
                    width: 72,
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.home, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.video_collection,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.subscriptions, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.person, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        left: _drawerOpen ? 240 : 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: _buildDesktopLayout(),
                      ),

                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        left: _drawerOpen ? 0 : -240,
                        top: 0,
                        bottom: 0,
                        child: Material(
                          elevation: 16,
                          child: SizedBox(
                            width: 240,
                            child: ListView(
                              children: [
                                ListTile(title: Text("Home")),
                                ListTile(title: Text("Shorts")),
                                ListTile(title: Text("Subscriptions")),
                                ListTile(title: Text("You")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
