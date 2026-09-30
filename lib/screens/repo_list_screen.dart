import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../main.dart';
import 'file_browser_screen.dart';

class RepoListBody extends StatelessWidget {
  final String token;
  final List<dynamic>? repos;
  final String? error;
  final Future<void> Function() onRefresh;
  const RepoListBody({
    super.key,
    required this.token,
    required this.repos,
    required this.error,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            children: [
              const Expanded(
                child: Text('Mes depots',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary)),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20, color: muted),
                onPressed: onRefresh,
              ),
            ],
          ),
        ),
        Expanded(
          child: error != null
              ? Center(child: Text(error!, style: const TextStyle(color: errorColor)))
              : repos == null
                  ? _buildShimmer()
                  : RefreshIndicator(
                      onRefresh: onRefresh,
                      color: violet,
                      backgroundColor: card,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                        itemCount: repos!.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final repo = repos![i] as Map<String, dynamic>;
                          final owner = repo['owner']['login'] as String;
                          final name = repo['name'] as String;
                          final priv = repo['private'] == true;
                          final branch = (repo['default_branch'] as String?) ?? 'main';
                          return _RepoTile(
                            name: name,
                            owner: owner,
                            private: priv,
                            branch: branch,
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => FileBrowserScreen(
                                token: token,
                                owner: owner,
                                repo: name,
                                path: '',
                                branch: branch,
                              ),
                            )),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: card,
        highlightColor: line,
        child: Container(
          height: 64,
          decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

class _RepoTile extends StatelessWidget {
  final String name;
  final String owner;
  final bool private;
  final String branch;
  final VoidCallback onTap;
  const _RepoTile({
    required this.name,
    required this.owner,
    required this.private,
    required this.branch,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: violet.withOpacity(.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_rounded, color: violet, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                  const SizedBox(height: 2),
                  Text('$owner . $branch',
                      style: const TextStyle(fontSize: 11, color: muted)),
                ],
              ),
            ),
            if (private) const Icon(Icons.lock_rounded, size: 14, color: muted),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 18, color: muted),
          ],
        ),
      ),
    );
  }
}
