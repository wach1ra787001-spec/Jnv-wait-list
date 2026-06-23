import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../theme.dart';
import '../models/waitlist_entry.dart';
import '../services/waitlist_service.dart';
import '../widgets/form_widgets.dart';
import '../widgets/theme_toggle.dart';
import 'success_screen.dart';

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  final _fullNameCtrl      = TextEditingController();
  final _preferredNameCtrl = TextEditingController();
  final _emailCtrl         = TextEditingController();
  final _phoneCtrl         = TextEditingController();

  String?       _expValue;
  final List<String> _markets  = [];
  bool?         _doesJournal;
  String?       _journalDur;
  final List<String> _methods  = [];

  bool    _submitting  = false;
  String? _serverError;
  bool    _mktError    = false;
  bool    _jrnError    = false;

  @override
  void initState() {
    super.initState();
    themeNotifier.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    themeNotifier.removeListener(_rebuild);
    _fullNameCtrl.dispose();
    _preferredNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();
    setState(() {
      _mktError = _markets.isEmpty;
      _jrnError = _doesJournal == null;
    });

    if (!formOk || _mktError || _jrnError) {
      _scrollCtrl.animateTo(0,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
      return;
    }

    setState(() {
      _submitting  = true;
      _serverError = null;
    });

    try {
      if (await WaitlistService.emailExists(_emailCtrl.text)) {
        setState(() {
          _serverError = 'This email is already on the waitlist.';
          _submitting  = false;
        });
        return;
      }

      await WaitlistService.submit(WaitlistEntry(
        fullName:          _fullNameCtrl.text.trim(),
        preferredName:     _preferredNameCtrl.text.trim(),
        email:             _emailCtrl.text.trim().toLowerCase(),
        phoneNumber:       _phoneCtrl.text.trim(),
        yearsOfExperience: int.tryParse(_expValue ?? '0') ?? 0,
        markets:           List.from(_markets),
        doesJournal:       _doesJournal!,
        journalDuration:   _doesJournal! ? _journalDur : null,
        previousMethods:   List.from(_methods),
        submittedAt:       DateTime.now(),
      ));

      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => SuccessScreen(
          preferredName: _preferredNameCtrl.text.trim().isNotEmpty
              ? _preferredNameCtrl.text.trim()
              : _fullNameCtrl.text.trim().split(' ').first,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ));
    } catch (_) {
      setState(() {
        _serverError = 'Something went wrong. Please try again.';
        _submitting  = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c      = AppColors(isDark: themeNotifier.isDark);
    final isWide = MediaQuery.of(context).size.width > 900;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: c.scaffold,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            if (isWide) _HeroPanel(c: c),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 24, vertical: 48),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: isWide ? 520 : double.infinity),
                    child: _buildForm(isWide, c),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isWide, AppColors c) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────
          if (!isWide) ...[
            Row(children: [
              Image.asset('assets/images/logo.png', width: 52, height: 52),
              const Spacer(),
              const ThemeToggleButton(),
            ]),
            const SizedBox(height: 20),
            Text('JNV Pro',
                style: GoogleFonts.syne(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.electric,
                    letterSpacing: 2)),
            const SizedBox(height: 8),
            Text('Join the waitlist',
                style: GoogleFonts.syne(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                    height: 1.15)),
            const SizedBox(height: 8),
            Text('Be first in line for early access.',
                style:
                    GoogleFonts.dmSans(fontSize: 14, color: c.textMuted)),
            const SizedBox(height: 32),
          ] else ...[
            Text('Join the waitlist',
                style: GoogleFonts.syne(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary)),
            const SizedBox(height: 6),
            Text('Tell us a bit about yourself and how you trade.',
                style:
                    GoogleFonts.dmSans(fontSize: 14, color: c.textMuted)),
            const SizedBox(height: 32),
          ],

          // ── Error banner ─────────────────────────────────────────
          if (_serverError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: c.errorBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.error.withValues(alpha: 0.4)),
              ),
              child: Text(_serverError!,
                  style:
                      GoogleFonts.dmSans(fontSize: 13, color: c.error)),
            ),
            const SizedBox(height: 20),
          ],

          // ══ SECTION 1 ═════════════════════════════════════════════
          const SectionLabel(step: '1', title: 'About you'),
          const SizedBox(height: 20),

          JnvTextField(
            label: 'Full name',
            hint: 'Your full name',
            controller: _fullNameCtrl,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter your full name'
                : null,
          ),
          const SizedBox(height: 16),

          JnvTextField(
            label: 'Preferred name / Nickname',
            hint: 'What should we call you?',
            controller: _preferredNameCtrl,
            prefixIcon: const Icon(Icons.badge_outlined),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter a preferred name'
                : null,
          ),
          const SizedBox(height: 16),

          JnvTextField(
            label: 'Email address',
            hint: 'you@example.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline_rounded),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your email';
              }
              final valid = RegExp(
                      r'^[\w\.\+\-]+@[\w\-]+\.[a-z]{2,}$',
                      caseSensitive: false)
                  .hasMatch(v.trim());
              return valid ? null : 'Please enter a valid email';
            },
          ),
          const SizedBox(height: 16),

          JnvTextField(
            label: 'Phone number',
            hint: '+254 7XX XXX XXX',
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter your phone number'
                : null,
          ),

          const SizedBox(height: 36),
          _divider(c),
          const SizedBox(height: 36),

          // ══ SECTION 2 ═════════════════════════════════════════════
          const SectionLabel(step: '2', title: 'Your trading background'),
          const SizedBox(height: 20),

          JnvSelectField(
            label: 'Years of trading experience',
            value: _expValue,
            hint: 'Select your experience level',
            options: kExperienceOptions
                .map((e) => {
                      'label': e['label']!,
                      'value': e['value']!,
                    })
                .toList(),
            onChanged: (v) => setState(() => _expValue = v),
            validator: (v) =>
                v == null ? 'Please select your experience level' : null,
          ),
          const SizedBox(height: 20),

          JnvMultiChip(
            label: 'Markets you trade',
            subtitle: 'Select all that apply',
            options: kMarkets,
            selected: _markets,
            errorText:
                _mktError ? 'Please select at least one market' : null,
            onToggle: (opt, val) => setState(() {
              val ? _markets.add(opt) : _markets.remove(opt);
              _mktError = _markets.isEmpty;
            }),
          ),

          const SizedBox(height: 36),
          _divider(c),
          const SizedBox(height: 36),

          // ══ SECTION 3 ═════════════════════════════════════════════
          const SectionLabel(step: '3', title: 'Your journalling habits'),
          const SizedBox(height: 20),

          JnvYesNo(
            label: 'Do you currently journal your trades?',
            value: _doesJournal,
            errorText: _jrnError ? 'Please select an option' : null,
            onChanged: (v) =>
                setState(() {
                  _doesJournal = v;
                  _jrnError    = false;
                }),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
            child: _doesJournal == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: JnvSelectField(
                      label: 'How long have you been journalling?',
                      value: _journalDur,
                      hint: 'Select duration',
                      options: kJournalDurations
                          .map((d) => {'label': d, 'value': d})
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _journalDur = v),
                      validator: (_doesJournal == true)
                          ? (v) => v == null
                              ? 'Please select a duration'
                              : null
                          : null,
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 20),

          JnvMultiChip(
            label: 'Previous journalling methods used',
            subtitle: 'Select all that apply',
            options: kPreviousMethods,
            selected: _methods,
            onToggle: (opt, val) => setState(() {
              val ? _methods.add(opt) : _methods.remove(opt);
            }),
          ),

          const SizedBox(height: 40),

          // ── Submit button ─────────────────────────────────────────
          ElevatedButton(
            onPressed: _submitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: c.electric,
              disabledBackgroundColor: c.electric.withValues(alpha: 0.45),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: _submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text('Join the waitlist  →',
                    style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
          ),

          const SizedBox(height: 14),
          Center(
            child: Text(
              "No spam. Ever. We'll only reach out when it matters.",
              style:
                  GoogleFonts.dmSans(fontSize: 12, color: c.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _divider(AppColors c) => Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            c.divider.withValues(alpha: 0),
            c.divider,
            c.divider.withValues(alpha: 0),
          ]),
        ),
      );
}

// ─── Hero panel ──────────────────────────────────────────────────

class _HeroPanel extends StatelessWidget {
  final AppColors c;
  const _HeroPanel({required this.c});

  static const _features = [
    (Icons.analytics_outlined,      'Advanced performance analytics'),
    (Icons.psychology_outlined,     'Streaks & discipline tracking'),
    (Icons.auto_graph_rounded,      'AI-powered session reports'),
    (Icons.calendar_today_outlined, 'Economic calendar integration'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 400,
      color: c.heroBg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle dot grid background
          CustomPaint(painter: _GridPainter(color: c.gridLine)),
          // Scrollable so it never overflows on short screens
          SingleChildScrollView(
            padding: const EdgeInsets.all(44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo + theme toggle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo.png',
                            width: 68, height: 68)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1)),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: ThemeToggleButton(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text('JNV Pro',
                    style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.electric,
                        letterSpacing: 2.5))
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 500.ms),

                const SizedBox(height: 10),

                Text('Your edge\nstarts with\nclarity.',
                    style: GoogleFonts.syne(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                        height: 1.12,
                        letterSpacing: -1))
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 600.ms)
                    .slideY(begin: 0.15, end: 0),

                const SizedBox(height: 20),

                Text(
                  'The professional trade journal built for traders who treat their craft as a business.',
                  style: GoogleFonts.dmSans(
                      fontSize: 14, color: c.textSecondary, height: 1.65),
                ).animate().fadeIn(delay: 350.ms, duration: 600.ms),

                const SizedBox(height: 40),

                // Feature list — fixed gaps, no Spacer
                for (final f in _features)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: c.electric.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: c.electric.withValues(alpha: 0.2)),
                          ),
                          child: Icon(f.$1, color: c.electric, size: 17),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(f.$2,
                              style: GoogleFonts.dmSans(
                                  fontSize: 13, color: c.textSecondary)),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 450.ms)
                      .slideX(begin: -0.08, end: 0),

                const SizedBox(height: 40),

                // Early access badge
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: c.success, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Text('Early access — limited spots',
                          style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: c.textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Grid background painter ─────────────────────────────────────

class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (var x = 0.0; x < size.width;  x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
