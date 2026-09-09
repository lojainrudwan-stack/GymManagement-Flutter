import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Gallery screen – displays the 3 gym interior images (reference images 3, 4, 5).
/// The user can swipe or tap arrows to navigate. Tapping the back arrow on image 1
/// returns to the Welcome screen.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<String> _assets = [
    'assets/images/gym_gallery_1.png',
    'assets/images/gym_gallery_2.png',
    'assets/images/gym_gallery_3.png',
  ];

  void _goNext() {
    if (_currentPage < _assets.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page → loop back to first
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goPrev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      // First page → go back to Welcome
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Force LTR so the left/right arrows always map to prev/next regardless
      // of the global RTL locale.
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Full-screen page view ─────────────────────────────────────
            PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _assets[index],
                  fit: BoxFit.cover,
                );
              },
            ),

            // ── Bottom bar: arrow left | logo | arrow right ───────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 36),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ← Previous
                    _ArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onPressed: _goPrev,
                    ),

                    // Centre logo
                    const _LandmarksLogo(),

                    // → Next
                    _ArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onPressed: _goNext,
                    ),
                  ],
                ),
              ),
            ),

            // ── Page dots indicator (optional, mirrors the reference) ─────
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _assets.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == i ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == i
                          ? Colors.white
                          : Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable arrow button ─────────────────────────────────────────────────
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black26,
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}

// ── LANDMARKS ARCHITECTS logo (text only, matching the reference) ─────────
class _LandmarksLogo extends StatelessWidget {
  const _LandmarksLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Simple mountain/peaks icon as logo placeholder
        const Icon(Icons.landscape_rounded, color: Colors.white70, size: 28),
        const SizedBox(height: 2),
        Text(
          'LANDMARKS',
          style: GoogleFonts.lato(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        Text(
          'ARCHITECTS',
          style: GoogleFonts.lato(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
