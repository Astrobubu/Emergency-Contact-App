
class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final String avatarUrl; // We can use assets or network
  final bool isSafe;
  final String lastSeen;
  final double? latitude;
  final double? longitude;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    this.avatarUrl = '',
    this.isSafe = true,
    this.lastSeen = 'Just now',
    this.latitude,
    this.longitude,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      name: json['name'],
      relation: json['relation'] ?? 'Member',
      avatarUrl: json['avatar_url'] ?? '',
      isSafe: json['is_safe'] ?? true,
      lastSeen: json['last_seen'] ?? 'Unknown',
    );
  }
}
