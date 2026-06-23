class WaitlistEntry {
  final String fullName;
  final String preferredName;
  final String email;
  final String phoneNumber;
  final int yearsOfExperience;
  final List<String> markets;
  final bool doesJournal;
  final String? journalDuration;
  final List<String> previousMethods;
  final DateTime submittedAt;

  const WaitlistEntry({
    required this.fullName,
    required this.preferredName,
    required this.email,
    required this.phoneNumber,
    required this.yearsOfExperience,
    required this.markets,
    required this.doesJournal,
    this.journalDuration,
    required this.previousMethods,
    required this.submittedAt,
  });

  Map<String, dynamic> toJson() => {
    'full_name':           fullName,
    'preferred_name':      preferredName,
    'email':               email,
    'phone_number':        phoneNumber,
    'years_of_experience': yearsOfExperience,
    'markets':             markets,
    'does_journal':        doesJournal,
    'journal_duration':    journalDuration,
    'previous_methods':    previousMethods,
    'submitted_at':        submittedAt.toIso8601String(),
  };
}

// ── Constant data ────────────────────────────────────────────────

const kMarkets = ['CFDs', 'Futures', 'Stocks', 'Crypto'];

const kJournalDurations = [
  'Less than 3 months',
  '3–6 months',
  '6–12 months',
  '1–2 years',
  '2+ years',
];

const kPreviousMethods = [
  'Spreadsheets (Excel / Google Sheets)',
  'Notion / Obsidian',
  'TraderVue',
  'Edgewonk',
  'Tradersync',
  'MyFXBook',
  'Paper / Physical journal',
  "I haven't journalled before",
];

const kExperienceOptions = [
  {'label': 'Under 1 year', 'value': '0'},
  {'label': '1–2 years',    'value': '1'},
  {'label': '3–5 years',    'value': '3'},
  {'label': '5–10 years',   'value': '5'},
  {'label': '10+ years',    'value': '10'},
];
