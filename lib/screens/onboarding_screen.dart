import 'package:flutter/material.dart';
import 'login_screen.dart';

class _ObPage {
  final IconData icon;
  final String title;
  final String text;
  final List<Color> colors;
  const _ObPage(this.icon, this.title, this.text, this.colors);
}

const _pages = [
  _ObPage(
    Icons.hub_rounded,
    'Tous tes depots,\ndans ta poche.',
    'Accede a tous tes projets GitHub directement depuis ton telephone, ou que tu sois.',
    [Color(0xFF7C5CFF), Color(0xFF3FD1C7)],
  ),
  _ObPage(
    Icons.code_rounded,
    'Edite ton code\nen un instant.',
    'Ouvre, modifie et navigue dans tes fichiers avec un editeur colore et fluide.',
    [Color(0xFFFF6BD6), Color(0xFF7C5CFF)],
  ),
  _ObPage(
    Icons.cloud_upload_rounded,
    'Commit & push\nou que tu sois.',
    'Pousse tes changements sur GitHub en un tap, sans ouvrir un ordinateur.',
    [Color(0xFFFFB454), Color(0xFFFF6B6B)],
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  void _goLogin() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) => const LoginScreen(),
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
    ));
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _goLogin();
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_index];
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.4, -0.7),
                radius: 1.1,
                colors: [page.colors[0].withOpacity(.55), const Color(0xFF0E0B1A)],
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.8, 0.8),
                  radius: 1.0,
                  colors: [page.colors[1].withOpacity(.45), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextButton(
                      onPressed: _goLogin,
                      child: const Text('Passer',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (_, i) {
                      final p = _pages[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.12),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(p.icon, color: Colors.white, size: 30),
                            ),
                            const SizedBox(height: 26),
                            Text(p.title,
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    height: 1.2)),
                            const SizedBox(height: 12),
                            Text(p.text,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70, height: 1.4)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 36),
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(_pages.length, (i) {
                          final active = i == _index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            width: active ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active ? Colors.white : Colors.white24,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _next,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _index == _pages.length - 1 ? 150 : 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: _index == _pages.length - 1
                              ? const Text('Commencer',
                                  style: TextStyle(
                                      color: Color(0xFF0E0B1A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14))
                              : const Icon(Icons.arrow_forward_rounded,
                                  color: Color(0xFF0E0B1A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
