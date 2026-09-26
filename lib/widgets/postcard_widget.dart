import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/widgets/like_animation.dart';
import 'package:social_app/widgets/modalbottomsheet.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String username;
  final String uid;
  final String caption;
  final String photoUrl;
  final Timestamp? createdAt;
  final String avatarUrl;
  final List likes;

  const PostCard({
    super.key,
    required this.postId,
    required this.username,
    required this.uid,
    required this.caption,
    required this.photoUrl,
    required this.likes,
    required this.avatarUrl,
    this.createdAt,
  });


  String _timeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final DateTime postTime = timestamp.toDate();
    final Duration diff = DateTime.now().difference(postTime);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else {
      return '${(diff.inDays / 30).floor()}mo ago';
    }
  }

  @override
  Widget build(BuildContext context) {

    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    final bool isLiked = currentUid != null && likes.contains(currentUid);
    final bool isOwnPost = currentUid != null && currentUid == uid;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black87,
              ),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: avatarUrl.isNotEmpty
                          ? Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/avatar/black-man.png', fit: BoxFit.cover),
                      )
                          : Image.asset('assets/avatar/black-man.png', fit: BoxFit.cover),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      username,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),

                  isOwnPost
                      ? SizedBox.shrink()
                      : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Sheet(username: username, posterUid: uid),
                        );
                      },
                      child: Icon(Icons.more_horiz, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          LikeSection(
            postId: postId,
            key: ValueKey(postId),
            imageUrl: photoUrl,
            initialLikeCount: likes.length,
            isLiked: isLiked,
            imageHeight: MediaQuery.of(context).size.height * 0.35,
            trailing: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.comment_outlined, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 6),
                const Text('112', style: TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    "assets/pngs/message.png",
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Builder(
              builder: (context) {
                final timeWidget = Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _timeAgo(createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.white38),
                  ),
                );


                if (caption.trim().isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "$username  ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          children: const [
                            TextSpan(
                              text: "No caption",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      timeWidget,
                    ],
                  );
                }

                final captionText = TextSpan(
                  text: "$username  ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: caption,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                );

                return LayoutBuilder(
                  builder: (context, constraints) {

                    final tp = TextPainter(
                      text: captionText,
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);
                    final bool isOverflowing = tp.didExceedMaxLines;

                    if (!isOverflowing) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(captionText),
                          timeWidget,
                        ],
                      );
                    }

                    return StatefulBuilder(
                      builder: (context, _) {
                        bool isExpanded = false;
                        return StatefulBuilder(
                          builder: (context, setLocalState) {
                            if (!isExpanded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text.rich(
                                          captionText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => setLocalState(() => isExpanded = true),
                                        child: const Text(
                                          "more",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  timeWidget,
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      Text.rich(captionText),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => setLocalState(() => isExpanded = false),
                                        child: const Text(
                                          "less",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  timeWidget,
                                ],
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}