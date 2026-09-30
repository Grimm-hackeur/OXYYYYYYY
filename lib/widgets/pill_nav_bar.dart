import 'package:flutter/material.dart';
import '../main.dart';

class PillNavBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;
  const PillNavBar({
    super.key,
    required this.index,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  State<PillNavBar> createState() => _PillNavBarState();
}

class _PillNavBarState extends State<PillNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Widget _item(IconData icon, int index) {
    final active = widget.index == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap(index),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19, color: active ? Colors.white : muted),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 4 : 0,
              height: 4,
              decoration: const BoxDecoration(color: violet, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xF01A1530),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: line, width: .6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _item(Icons.home_rounded, 0),
            const SizedBox(width: 14),
            _item(Icons.folder_rounded, 1),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: widget.onCenterTap,
              child: SizedBox(
                width: 46,
                height: 46,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) {
                    final v = _pulse.value;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: (1 - v) * .55,
                          child: Transform.scale(
                            scale: 1 + v * .7,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: violet, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF9B7DFF), violet],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.search_rounded,
                              color: Colors.white, size: 19),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 6),
            _item(Icons.person_rounded, 2),
          ],
        ),
      ),
    );
  }
}
