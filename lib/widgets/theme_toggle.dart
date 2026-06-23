import 'package:flutter/material.dart';
import '../main.dart';

/// Animated pill toggle — moon left (dark mode), sun right (light mode).
class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
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
    final isDark = themeNotifier.isDark;

    final trackColor  = isDark ? const Color(0xFF1A2D4A) : const Color(0xFFDBEAFE);
    final trackBorder = isDark ? const Color(0xFF2E4A72) : const Color(0xFF93C5FD);
    final knobColor   = isDark ? const Color(0xFF3B7BF8) : const Color(0xFF2563EB);
    final moonColor   = isDark ? const Color(0xFF5B9BFF) : const Color(0xFF93C5FD);
    final sunColor    = isDark ? const Color(0xFF8BA3C4) : const Color(0xFF2563EB);

    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: GestureDetector(
        onTap: themeNotifier.toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 56,
          height: 30,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: trackBorder),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Moon — left
              Positioned(
                left: 6,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isDark ? 1.0 : 0.3,
                  child: Icon(Icons.dark_mode_rounded, size: 13, color: moonColor),
                ),
              ),
              // Sun — right
              Positioned(
                right: 6,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isDark ? 0.3 : 1.0,
                  child: Icon(Icons.wb_sunny_rounded, size: 13, color: sunColor),
                ),
              ),
              // Sliding knob
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: knobColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: knobColor.withValues(alpha: 0.45),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
                        key: ValueKey(isDark),
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
