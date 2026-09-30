import 'package:flutter/material.dart';
import '../main.dart';
import '../services/secure_store.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String? login;
  final String? avatarUrl;
  const ProfileScreen({super.key, this.login, this.avatarUrl});

  Future<void> _logout(BuildContext context) async {
    await SecureStore.clearToken();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 110),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: card,
                  border: Border.all(color: line, width: .8),
                  image: avatarUrl != null
                      ? DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: avatarUrl == null
                    ? const Icon(Icons.person_rounded, color: muted, size: 32)
                    : null,
              ),
              const SizedBox(height: 14),
              Text(login ?? 'Compte GitHub',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary)),
              const SizedBox(height: 2),
              const Text('Connecte via token personnel',
                  style: TextStyle(fontSize: 12, color: muted)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _Tile(icon: Icons.info_outline_rounded, label: 'GitPocket - v1.0'),
        const SizedBox(height: 10),
        _Tile(
          icon: Icons.logout_rounded,
          label: 'Se deconnecter',
          color: errorColor,
          onTap: () => _logout(context),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  const _Tile({required this.icon, required this.label, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: line, width: .6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color ?? muted),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 13.5, color: color ?? textPrimary)),
          ],
        ),
      ),
    );
  }
}
