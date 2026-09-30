import 'package:flutter/material.dart';
import '../main.dart';
import 'main_shell.dart';

class ValidationScreen extends StatefulWidget {
  final String token;
  const ValidationScreen({super.key, required this.token});
  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => MainShell(token: widget.token),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
        ),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final ring = const Interval(0, .5, curve: Curves.easeOut).transform(_c.value);
            final check = const Interval(.35, .8, curve: Curves.elasticOut).transform(_c.value);
            final text = const Interval(.6, 1, curve: Curves.easeOut).transform(_c.value);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: successColor.withOpacity(.12),
                      ),
                    ),
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: CircularProgressIndicator(
                        value: ring,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation(successColor),
                      ),
                    ),
                    Transform.scale(
                      scale: check.clamp(0.0, 1.3),
                      child: const Icon(Icons.check_rounded,
                          size: 40, color: successColor),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Opacity(
                  opacity: text.clamp(0.0, 1.0),
                  child: const Column(
                    children: [
                      Text('Connexion reussie',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: textPrimary)),
                      SizedBox(height: 4),
                      Text('Ouverture de ton espace...',
                          style: TextStyle(fontSize: 12, color: muted)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
