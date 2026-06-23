import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/waitlist_entry.dart';

class WaitlistService {
  static SupabaseClient get _db => Supabase.instance.client;

  /// Insert a new waitlist entry.
  static Future<void> submit(WaitlistEntry entry) async {
    await _db.from('waitlist').insert(entry.toJson());
  }

  /// Returns true if the email is already registered.
  static Future<bool> emailExists(String email) async {
    final result = await _db
        .from('waitlist')
        .select('id')
        .eq('email', email.trim().toLowerCase())
        .maybeSingle();
    return result != null;
  }
}
