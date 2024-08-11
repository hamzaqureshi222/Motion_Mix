import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:motion_mix/controllers/profile_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/chats_controller.dart';
import 'chat_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController authController = Get.put(AuthController());
  late TabController tabController;
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    profileController.updateUserId(uid);
    tabController = TabController(
      length: uid == authController.user.uid ? 3 : 1,
      vsync: this,
    );

    // Listener to update the tab icons based on the current index
    tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Query getUserVideos(String uid) {
    return FirebaseFirestore.instance.collection('videos').where('uid', isEqualTo: uid);
  }

  Query getBookmarkVideos(String uid) {
    return FirebaseFirestore.instance.collection('videos').where('bookmarks', arrayContains: uid);
  }

  Query getLikedVideos(String uid) {
    return FirebaseFirestore.instance.collection('videos').where('likes', arrayContains: uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        if (controller.user == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Use default values or null-aware operators
          final String name = controller.user["name"] ?? "";
          final String profilePhoto = controller.user["profilePhoto"] ?? "";
          final String following = controller.user["following"]?.toString() ?? "0";
          final String followers = controller.user["followers"]?.toString() ?? "0";
          final String likes = controller.user["likes"]?.toString() ?? "0";
          final bool isFollowing = controller.user["isFollowing"] ?? false;
          final bool isCurrentUser = uid == authController.user.uid;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                name,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              actions: [
                if (isCurrentUser)
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () {
                      Get.find<AuthController>().signOut();
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.black),
                    onPressed: () {
                      Get.to(  const ChatScreen(), arguments: [name, uid, profilePhoto]);
                    },
                  ),
                const WidthBox(10)
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const HeightBox(50),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profilePhoto,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        name,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const HeightBox(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                following,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const WidthBox(20),
                          Column(
                            children: [
                              Text(
                                followers,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                          const WidthBox(20),
                          Column(
                            children: [
                              Text(
                                likes,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const Text(
                                "Likes",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const HeightBox(10),
                      GestureDetector(
                        onTap: () {
                          if (isCurrentUser) {
                            authController.signOut();
                          } else {
                            controller.followUser();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const WidthBox(8),
                            isCurrentUser
                                ? Container()
                                : isFollowing
                                ? Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(13))),
                              height: 50,
                              width: 115,
                              child: const Center(
                                child: Text(
                                  "Unfollow",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            )
                                : Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(13))),
                              height: 50,
                              width: 115,
                              child: const Center(
                                child: Text(
                                  "Follow",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const HeightBox(5),
                  TabBar(
                    controller: tabController,
                    indicatorColor: Colors.black,
                    tabs: isCurrentUser
                        ? [
                      Tab(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          tabController.index == 1 ? Icons.bookmark : Icons.bookmark_border_outlined,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          tabController.index == 2 ? Icons.favorite : Icons.favorite_border,
                          color: Colors.black,
                        ),
                      ),
                    ]
                        : [
                      Tab(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: isCurrentUser
                          ? [
                        StreamBuilder<QuerySnapshot>(
                          stream: getUserVideos(uid).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            var videos = snapshot.data!.docs;
                            return GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                var video = videos[index];
                                return VideoThumbnail(
                                    videoUrl: video['videoUrl']);
                              },
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: getBookmarkVideos(uid).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            var videos = snapshot.data!.docs;
                            return GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                var video = videos[index];
                                return VideoThumbnail(
                                    videoUrl: video['videoUrl']);
                              },
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: getLikedVideos(uid).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            var videos = snapshot.data!.docs;
                            return GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                var video = videos[index];
                                return VideoThumbnail(
                                    videoUrl: video['videoUrl']);
                              },
                            );
                          },
                        ),
                      ]
                          : [
                        StreamBuilder<QuerySnapshot>(
                          stream: getUserVideos(uid).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            var videos = snapshot.data!.docs;
                            return GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                var video = videos[index];
                                return VideoThumbnail(
                                    videoUrl: video['videoUrl']);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnail({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.black));
        }
      },
    );
  }
}
