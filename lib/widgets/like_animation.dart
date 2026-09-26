
import 'package:flutter/material.dart';
import 'package:social_app/services/firestore_service.dart';

class LikeSection extends StatefulWidget {
  final String postId;
  final String imageUrl;
  final int initialLikeCount;
  final bool isLiked;
  final double imageHeight;
  final Widget? trailing;

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

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    _updateFirestore(isLiked);
  }

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
          const SnackBar(content: Text("Like not saved!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        GestureDetector(
          onDoubleTap: _onDoubleTapImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: widget.imageUrl.isEmpty
                    ? Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                )
                    : Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      ),
                    );
                  },
                ),
              ),


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
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 8),

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