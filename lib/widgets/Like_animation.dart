import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/firestore_service.dart';

/// LikeSection: image ke upar double-tap se like (gradient heart animation)
/// + neeche like button (heart icon) jo tap karne se red/white toggle hota hai
/// aur like count bhi automatically increase/decrease karta hai.
/// Firestore ke sath bhi sync rehta hai (postId ke zariye).
///
/// Use karne ka tareeqa:
/// LikeSection(
///   postId: post.postId,
///   imageUrl: post.imageUrl,
///   initialLikeCount: post.likes.length,
///   isLiked: post.likes.contains(currentUid),
/// )
class LikeSection extends StatefulWidget {
  final String postId;
  final String imageUrl;
  final int initialLikeCount;
  final bool isLiked;
  final double imageHeight;
  final Widget? trailing; // ✅ comment/share icons yahan se pass kar sakte ho

  const LikeSection({
    super.key,
    required this.postId,
    required this.imageUrl,
    required this.initialLikeCount,
    this.isLiked = false,
    this.imageHeight = 350,
    this.trailing,
  });

  @override
  State<LikeSection> createState() => _LikeSectionState();
}

class _LikeSectionState extends State<LikeSection>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();

  late bool isLiked;
  late int likeCount;

  // Double-tap heart pop-up animation ke liye
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _showHeartOverlay = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    likeCount = widget.initialLikeCount;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Bottom heart button se like/dislike toggle karta hai
  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    _updateFirestore(isLiked);
  }

  /// Double-tap se sirf LIKE karta hai (Instagram jaisa — unlike nahi karta)
  /// aur gradient heart animation dikhata hai
  void _onDoubleTapImage() async {
    if (!isLiked) {
      setState(() {
        isLiked = true;
        likeCount += 1;
      });
      _updateFirestore(true);
    }

    setState(() => _showHeartOverlay = true);
    await _animController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() => _showHeartOverlay = false);
    }
  }

  /// Firestore mein like status save karta hai. Agar fail ho (jaise internet
  /// na ho) to UI ko wapis purani state pe le aata hai.
  void _updateFirestore(bool liked) async {
    try {
      await _firestoreService.setLikeStatus(widget.postId, liked);
    } catch (e) {
      if (mounted) {
        setState(() {
          isLiked = !liked;
          likeCount += liked ? -1 : 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Like save nahi ho saka, dobara try karo")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Image + double tap heart animation ----------
        GestureDetector(
          onDoubleTap: _onDoubleTapImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: widget.imageHeight,
                width: double.infinity,
                child: widget.imageUrl.isEmpty
                    ? Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                )
                    : CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
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

              // ✅ Double tap pe gradient heart pop-up
              if (_showHeartOverlay)
                ScaleTransition(
                  scale: _scaleAnim,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 110,
                      color: Colors.white, // ShaderMask isi color ko gradient se replace karega
                    ),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 8),

        // ---------- Neeche like button + count (+ trailing icons agar diye hon) ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$likeCount',
                style: TextStyle(
                  color: isLiked ? Colors.red : Colors.white,
                  fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 16),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}