import 'package:flutter/material.dart';
import '../main.dart';
import '../services/github_api.dart';
import '../services/secure_store.dart';
import '../widgets/pill_nav_bar.dart';
import 'file_browser_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'repo_list_screen.dart';

class MainShell extends StatefulWidget {
  final String token;
  const MainShell({super.key, required this.token});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final GitHubApi _api = GitHubApi(widget.token);
  int _index = 0;
  List<dynamic>? _repos;
  String? _error;
  String? _login;
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadRepos();
  }

  Future<void> _loadUser() async {
    final login = await SecureStore.getLogin();
    final avatar = await SecureStore.getAvatar();
    if (mounted) setState(() {
      _login = login;
      _avatar = avatar;
    });
  }

  Future<void> _loadRepos() async {
    setState(() => _error = null);
    try {
      final repos = await _api.listRepos();
      if (mounted) setState(() => _repos = repos);
    } catch (e) {
      if (mounted) setState(() => _error = 'Impossible de charger les depots');
    }
  }

  void _openSearch() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _RepoSearchSheet(token: widget.token, repos: _repos ?? []),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(token: widget.token, login: _login, repos: _repos),
      RepoListBody(
        token: widget.token,
        repos: _repos,
        error: _error,
        onRefresh: _loadRepos,
      ),
      ProfileScreen(login: _login, avatarUrl: _avatar),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: tabs),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Center(
          child: PillNavBar(
            index: _index,
            onTap: (i) => setState(() => _index = i),
            onCenterTap: _openSearch,
          ),
        ),
      ),
    );
  }
}

class _RepoSearchSheet extends StatefulWidget {
  final String token;
  final List<dynamic> repos;
  const _RepoSearchSheet({required this.token, required this.repos});

  @override
  State<_RepoSearchSheet> createState() => _RepoSearchSheetState();
}

class _RepoSearchSheetState extends State<_RepoSearchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = widget.repos.where((r) {
      final name = (r['name'] as String).toLowerCase();
      return name.contains(_query.toLowerCase());
    }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * .7,
        decoration: const BoxDecoration(
          color: card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: line, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Rechercher un depot...',
                hintStyle: const TextStyle(color: muted, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: muted),
                filled: true,
                fillColor: bg,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text('Aucun resultat', style: TextStyle(color: muted, fontSize: 12)))
                  : ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final repo = results[i] as Map<String, dynamic>;
                        final owner = repo['owner']['login'] as String;
                        final name = repo['name'] as String;
                        final branch = (repo['default_branch'] as String?) ?? 'main';
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => FileBrowserScreen(
                                token: widget.token,
                                owner: owner,
                                repo: name,
                                path: '',
                                branch: branch,
                              ),
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: line, width: .5),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.folder_rounded, size: 16, color: violet),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(name,
                                      style: const TextStyle(fontSize: 13, color: textPrimary)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
