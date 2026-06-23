import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../theme.dart';

// Shorthand for current colors
AppColors get _c => AppColors(isDark: themeNotifier.isDark);

// ─── Text field ──────────────────────────────────────────────────

class JnvTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? prefixIcon;

  const JnvTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.dmSans(color: c.textPrimary, fontSize: 15),
          cursorColor: c.electric,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: c.surface,
            hintStyle: GoogleFonts.dmSans(color: c.textMuted, fontSize: 14),
            errorStyle: GoogleFonts.dmSans(color: c.error, fontSize: 12),
            prefixIcon: prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(color: c.textMuted, size: 18),
                    child: prefixIcon!)
                : null,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.electric, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.error)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.error, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

// ─── Select / Dropdown ───────────────────────────────────────────

class JnvSelectField extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, dynamic>> options;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String hint;

  const JnvSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.hint = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.textSecondary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          validator: validator,
          onChanged: onChanged,
          dropdownColor: c.surfaceLight,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.textMuted),
          style: GoogleFonts.dmSans(color: c.textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: c.surface,
            hintStyle: GoogleFonts.dmSans(color: c.textMuted, fontSize: 14),
            errorStyle: GoogleFonts.dmSans(color: c.error, fontSize: 12),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.electric, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: c.error)),
          ),
          items: options
              .map((o) => DropdownMenuItem<String>(
                    value: o['value'].toString(),
                    child: Text(o['label'] as String,
                        style: GoogleFonts.dmSans(
                            color: c.textPrimary, fontSize: 14)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── Multi-select chip group ─────────────────────────────────────

class JnvMultiChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final List<String> options;
  final List<String> selected;
  final void Function(String, bool) onToggle;
  final String? errorText;

  const JnvMultiChip({
    super.key,
    required this.label,
    this.subtitle,
    required this.options,
    required this.selected,
    required this.onToggle,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.textSecondary)),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(subtitle!,
              style: GoogleFonts.dmSans(fontSize: 12, color: c.textMuted)),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final sel = selected.contains(opt);
            return GestureDetector(
              onTap: () => onToggle(opt, !sel),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? c.chipSelected : c.surface,
                  border: Border.all(
                      color: sel ? c.electric : c.border,
                      width: sel ? 1.5 : 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (sel) ...[
                      Icon(Icons.check_rounded, size: 14, color: c.electric),
                      const SizedBox(width: 6),
                    ],
                    Text(opt,
                        style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight:
                                sel ? FontWeight.w600 : FontWeight.w400,
                            color:
                                sel ? c.electricBright : c.textSecondary)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!,
              style: GoogleFonts.dmSans(fontSize: 12, color: c.error)),
        ],
      ],
    );
  }
}

// ─── Yes / No toggle ─────────────────────────────────────────────

class JnvYesNo extends StatelessWidget {
  final String label;
  final bool? value;
  final void Function(bool) onChanged;
  final String? errorText;

  const JnvYesNo({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.textSecondary)),
        const SizedBox(height: 12),
        Row(children: [
          _opt(true, 'Yes, I journal', c),
          const SizedBox(width: 10),
          _opt(false, 'No, not yet', c),
        ]),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(errorText!,
              style: GoogleFonts.dmSans(fontSize: 12, color: c.error)),
        ],
      ],
    );
  }

  Widget _opt(bool v, String lbl, AppColors c) {
    final sel = value == v;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: sel ? c.chipSelected : c.surface,
            border: Border.all(
                color: sel ? c.electric : c.border, width: sel ? 1.5 : 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(lbl,
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? c.electricBright : c.textSecondary)),
          ),
        ),
      ),
    );
  }
}

// ─── Section label ───────────────────────────────────────────────

class SectionLabel extends StatelessWidget {
  final String step;
  final String title;

  const SectionLabel({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: c.electric.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: c.electric.withValues(alpha: 0.35)),
          ),
          child: Center(
            child: Text(step,
                style: GoogleFonts.syne(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.electric)),
          ),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: c.textPrimary)),
      ],
    );
  }
}
