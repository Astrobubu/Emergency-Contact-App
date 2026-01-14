import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration and initialization
class SupabaseConfig {
  SupabaseConfig._();

  // Supabase credentials
  static const String supabaseUrl = 'https://hfunmktxvqtvyzycjjrv.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmdW5ta3R4dnF0dnl6eWNqanJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzOTY3OTksImV4cCI6MjA4Mzk3Mjc5OX0.agwufSrq76WKP1mQiH57dYAUkWzw-_ruhKvuF0zCyJ4';

  /// Initialize Supabase client
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get current user
  static User? get currentUser => client.auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Get current user ID
  static String? get currentUserId => currentUser?.id;
}

/// Extension for easier Supabase access
extension SupabaseClientExtension on SupabaseClient {
  /// Profiles table
  SupabaseQueryBuilder get profiles => from('profiles');

  /// Family groups table
  SupabaseQueryBuilder get familyGroups => from('family_groups');

  /// Family memberships table
  SupabaseQueryBuilder get familyMemberships => from('family_memberships');

  /// Contacts table
  SupabaseQueryBuilder get contacts => from('contacts');

  /// Medical records table
  SupabaseQueryBuilder get medicalRecords => from('medical_records');

  /// Medications table
  SupabaseQueryBuilder get medications => from('medications');

  /// Appointments table
  SupabaseQueryBuilder get appointments => from('appointments');

  /// Emergency IDs table
  SupabaseQueryBuilder get emergencyIds => from('emergency_ids');

  /// Insurance documents table
  SupabaseQueryBuilder get insuranceDocuments => from('insurance_documents');

  /// Documents table
  SupabaseQueryBuilder get documents => from('documents');

  /// Emergency protocols table
  SupabaseQueryBuilder get emergencyProtocols => from('emergency_protocols');

  /// Location updates table
  SupabaseQueryBuilder get locationUpdates => from('location_updates');

  /// Emergency alerts table
  SupabaseQueryBuilder get emergencyAlerts => from('emergency_alerts');

  /// Reminders table
  SupabaseQueryBuilder get reminders => from('reminders');
}
