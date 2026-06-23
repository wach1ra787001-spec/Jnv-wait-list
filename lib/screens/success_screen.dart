import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../theme.dart';

class SuccessScreen extends StatefulWidget {
  final String preferredName;
  const SuccessScreen({super.key, required this.preferredName});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
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
    final c = AppColors(isDark: themeNotifier.isDark);
    final isWide = MediaQuery.of(context).size.width > 700;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: c.scaffold,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isWide ? 0 : 24, vertical: 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Check circle
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: c.successBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: c.success.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Icon(Icons.check_rounded,
                        color: c.success, size: 48),
                  )
                      .animate()
                      .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          duration: 500.ms,
                          curve: Curves.elasticOut),

                  const SizedBox(height: 32),

                  Text("You're on the list,",
                      style: GoogleFonts.dmSans(
                          fontSize: 16, color: c.textMuted),
                      textAlign: TextAlign.center)
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 6),

                  Text(
                      widget.preferredName.isNotEmpty
                          ? widget.preferredName
                          : 'Trader',
                      style: GoogleFonts.syne(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                          height: 1.1),
                      textAlign: TextAlign.center)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 24),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: c.border),
                    ),
                    child: Text(
                      "We'll be in touch when early access opens. You'll be among the first traders to get hands on JNV Pro — built for serious traders who take their edge seriously.",
                      style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: c.textSecondary,
                          height: 1.7),
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _chip(Icons.bolt_rounded, 'Early access', c),
                      const SizedBox(width: 10),
                      _chip(Icons.notifications_none_rounded,
                          'Priority invite', c),
                    ],
                  ).animate().fadeIn(delay: 650.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, AppColors c) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: c.electric.withValues(alpha: 0.1),
          border:
              Border.all(color: c.electric.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: c.electric),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: c.electricBright)),
          ],
        ),
      );
}
