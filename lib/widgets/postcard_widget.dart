import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class postcard extends StatelessWidget {
  final String username;
  final String caption;
  final String photoUrl;
  final Timestamp? createdAt;

  const postcard({
    super.key,
    required this.username,
    required this.caption,
    required this.photoUrl,
    this.createdAt,
  });

  // ✅ Timestamp ko "2h ago", "3d ago" jaisi readable string mein convert karta hai
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
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ sab kuch left se start ho
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
                    child: Image.asset('assets/avatar/black-man.png'),
                  ),
                  Expanded(
                    child: Text(
                      username,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {},
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

          // image container
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            // ✅ Cloudinary se aayi URL hai, isliye Image.network use karo, Image.asset nahi
            child: photoUrl.isEmpty
                ? Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(Icons.image, color: Colors.grey, size: 40),
              ),
            )
                : CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              fadeInDuration: Duration.zero, // ✅ dobara dikhne pe flicker na ho
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.purple),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),

          // like container
          Padding(
            padding: EdgeInsets.only(right: 100, top: 8),
            child: Container(
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
                height: 35,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black87,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.favorite, color: Colors.red, size: 20),
                      ),
                    ),
                    Text('112', style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(width: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.comment_outlined, color: Colors.white, size: 20),
                      ),
                    ),
                    Text('112', style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(width: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/pngs/message.png",
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Caption — left aligned, more/less button caption ke saath usi line pe
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: StatefulBuilder(
              builder: (context, setLocalState) {
                bool isExpanded = false;
                return StatefulBuilder(
                  builder: (context, setLocalState2) {
                    final timeWidget = Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _timeAgo(createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    );

                    // ✅ Caption khali hai to "more"/"less" bilkul na dikhe, sirf "No caption"
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

                    if (!isExpanded) {
                      // Collapsed: caption (1 line, truncated) + "more" usi line pe, right side
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
                                onTap: () => setLocalState2(() => isExpanded = true),
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
                          timeWidget, // ✅ time caption ke neeche
                        ],
                      );
                    } else {
                      // Expanded: pura caption dikhega, "less" caption ke akhri word ke sath
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              Text.rich(captionText),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => setLocalState2(() => isExpanded = false),
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
                          timeWidget, // ✅ time caption ke neeche
                        ],
                      );
                    }
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