import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/family_member.dart';

class FamilyRepository {
  Future<List<FamilyMember>> getFamilyMembers() async {
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      const FamilyMember(id: '1', name: 'Mom', relation: 'Mother', isSafe: true, lastSeen: '10 min ago'),
      const FamilyMember(id: '2', name: 'Dad', relation: 'Father', isSafe: true, lastSeen: '1h ago'),
      const FamilyMember(id: '3', name: 'Sarah', relation: 'Sister', isSafe: true, lastSeen: 'Just now'),
      const FamilyMember(id: '4', name: 'Mike', relation: 'Brother', isSafe: true, lastSeen: '5 min ago'),
    ];
  }
}

final familyRepositoryProvider = Provider((ref) => FamilyRepository());

final familyMembersProvider = FutureProvider<List<FamilyMember>>((ref) async {
  final repository = ref.watch(familyRepositoryProvider);
  return repository.getFamilyMembers();
});
