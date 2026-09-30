import 'package:flutter/material.dart';
import '../main.dart';
import 'file_browser_screen.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  final String? login;
  final List<dynamic>? repos;
  const HomeScreen({super.key, required this.token, this.login, this.repos});

  @override
  Widget build(BuildContext context) {
    final recent = (repos ?? []).take(3).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
      children: [
        Text(
          login == null ? 'Bonjour' : 'Bonjour, $login',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary),
        ),
        const SizedBox(height: 4),
        const Text('Content de te revoir.', style: TextStyle(fontSize: 13, color: muted)),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.folder_rounded,
                value: repos == null ? '-' : repos!.length.toString(),
                label: 'Depots',
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: _StatCard(icon: Icons.bolt_rounded, value: 'V1', label: 'GitPocket'),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Text('Recents',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          const Text('Rien a afficher pour le moment.',
              style: TextStyle(fontSize: 12, color: muted))
        else
          ...recent.map((r) {
            final repo = r as Map<String, dynamic>;
            final owner = repo['owner']['login'] as String;
            final name = repo['name'] as String;
            final branch = (repo['default_branch'] as String?) ?? 'main';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FileBrowserScreen(
                    token: token,
                    owner: owner,
                    repo: name,
                    path: '',
                    branch: branch,
                  ),
                )),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: line, width: .6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: violet.withOpacity(.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.folder_rounded, color: violet, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(name,
                            style: const TextStyle(fontSize: 13.5, color: textPrimary)),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 16, color: muted),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: line, width: .6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: violet, size: 18),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: muted)),
        ],
      ),
    );
  }
}
