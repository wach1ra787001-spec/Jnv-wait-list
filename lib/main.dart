import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme.dart';
import 'screens/waitlist_screen.dart';

/// Global theme notifier — imported by every file that needs current theme.
final ThemeNotifier themeNotifier = ThemeNotifier();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // ── Replace these two values with your Supabase project credentials ──
    url: 'https://nivwvrjcifhntkokfsqe.supabase.co',
    anonKey: 'sb_publishable_KtoxGpLqycjyWRvzz_osZw_pLulxE5i',
    // ─────────────────────────────────────────────────────────────────────
  );

  runApp(const JnvApp());
}

class JnvApp extends StatefulWidget {
  const JnvApp({super.key});

  @override
  State<JnvApp> createState() => _JnvAppState();
}

class _JnvAppState extends State<JnvApp> {
  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    themeNotifier.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JNV Pro — Early Access',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(isDark: themeNotifier.isDark),
      home: const WaitlistScreen(),
    );
  }
}
