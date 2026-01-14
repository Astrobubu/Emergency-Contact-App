/// Route path constants for the app
class RouteNames {
  RouteNames._();

  // === AUTH ===
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // === MAIN TABS ===
  static const String home = '/';
  static const String family = '/family';
  static const String map = '/map';
  static const String contacts = '/contacts';
  static const String settings = '/settings';

  // === VAULT ===
  static const String medicalHub = '/medical';
  static const String medicalRecords = '/medical/records';
  static const String medications = '/medical/medications';
  static const String appointments = '/medical/appointments';
  static const String emergencyId = '/medical/emergency-id';

  static const String documentsVault = '/documents';
  static const String insuranceVault = '/insurance';
  static const String protocolsVault = '/protocols';

  // === FAMILY ===
  static const String familyGroupDetail = '/family/:id';
  static const String createFamily = '/family/create';
  static const String inviteMember = '/family/:id/invite';

  // === CONTACTS ===
  static const String contactDetail = '/contacts/:id';
  static const String addContact = '/contacts/add';

  // === EMERGENCY ===
  static const String emergencyTrigger = '/emergency/trigger';
  static const String emergencyReceived = '/emergency/received/:id';
  static const String publicEmergencyId = '/emergency-id/:userId';
}
