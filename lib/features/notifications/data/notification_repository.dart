import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/app_notification.dart';

class NotificationRepository {
  Future<List<AppNotification>> getUpcomingNotifications() async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      AppNotification(
        id: '1',
        title: 'Dr. Johnson Checkup',
        subtitle: 'Dad • Tomorrow 2:30 PM',
        type: NotificationType.medical,
        date: DateTime.now().add(const Duration(days: 1)),
      ),
      AppNotification(
        id: '2',
        title: 'Insurance Expiring',
        subtitle: 'Mom • Dec 25, 2025',
        type: NotificationType.insurance,
        date: DateTime(2025, 12, 25),
      ),
      AppNotification(
        id: '3',
        title: 'Medication Reminder',
        subtitle: 'Dad • 8:00 PM today',
        type: NotificationType.medical,
        date: DateTime.now(),
      ),
    ];
  }
}

final notificationRepositoryProvider = Provider((ref) => NotificationRepository());

final upcomingNotificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getUpcomingNotifications();
});
