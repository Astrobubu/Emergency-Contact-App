# Family Emergency Hub - Implementation Plan

## Overview
A Flutter app for family emergency coordination with Supabase backend featuring:
- Contact management & medical records
- Insurance/document vault (any file type)
- Real-time family location (Find My style)
- Emergency alerts with push notifications
- Medication/appointment reminders
- Lock screen emergency medical ID card

**Design**: Rounded, beige/warm cozy palette, slick animations (slide, scale, bounce - NO fading)

---

## Tech Stack
- **Flutter 3.10+** with Riverpod state management
- **Supabase**: Auth, PostgreSQL, Realtime, Storage, Edge Functions
- **GoRouter** for navigation with custom transitions
- **flutter_animate** + spring physics for animations
- **geolocator** + **flutter_background_service** for location
- **Firebase Messaging** for push notifications
- **home_widget** for lock screen medical ID

---

## Project Structure
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/           # Supabase config, constants
│   ├── theme/            # Beige color palette, rounded decorations
│   ├── router/           # GoRouter with slide/scale transitions
│   ├── animations/       # Spring curves, staggered lists, bounce effects
│   └── services/         # Location, notifications, storage
├── shared/
│   ├── data/models/      # All data models (freezed)
│   ├── providers/        # Global providers (supabase, user)
│   └── widgets/          # Reusable UI components
└── features/
    ├── auth/             # Login, register, forgot password
    ├── home/             # Dashboard with emergency FAB
    ├── family/           # Groups, members, invites
    ├── contacts/         # Contact management
    ├── medical/          # Records, medications, appointments, emergency ID
    ├── insurance/        # Insurance document vault
    ├── documents/        # General document vault
    ├── protocols/        # Emergency protocols
    ├── location/         # Family map (Find My style)
    ├── emergency/        # Alert trigger/receive screens
    ├── reminders/        # Medication & appointment reminders
    └── settings/         # Profile, notifications, privacy
```

---

## Database Schema (Supabase)

### Core Tables
| Table | Purpose |
|-------|---------|
| `profiles` | User profiles (extends auth.users), FCM tokens |
| `family_groups` | Family groups with invite codes |
| `family_memberships` | Junction table (users can be in multiple groups) |
| `contacts` | Personal/emergency contacts |
| `medical_records` | Health records with attachments |
| `medications` | Medications with reminder times |
| `appointments` | Appointments with reminders |
| `emergency_ids` | Lock screen medical ID data |
| `insurance_documents` | Insurance policies with files |
| `documents` | Document vault (any file type) |
| `emergency_protocols` | Family emergency procedures |
| `location_updates` | Real-time location tracking |
| `emergency_alerts` | Emergency alert broadcasts |
| `reminders` | Scheduled reminders |

### Storage Buckets
- `avatars` (public)
- `medical-files` (private)
- `insurance-documents` (private)
- `documents-vault` (private)

---

## Key Features Implementation

### 1. Real-time Location (Find My Style)
- **Background service** updates location every 30 seconds
- **Supabase Realtime** broadcasts to family members
- **Google Maps** displays family markers with avatars
- Battery-aware: reduce frequency on low battery

### 2. Emergency Alerts
- Big red emergency button on home screen
- Creates `emergency_alerts` record
- **Supabase Edge Function** sends FCM push to all family members
- Alert includes location + link to view on map

### 3. Document Vault
- **file_picker** for any file type
- Upload to Supabase Storage with metadata
- Offline caching with **Hive**
- Share with family toggle

### 4. Medical Reminders
- Local notifications via **flutter_local_notifications**
- Recurring schedules for medications
- Appointment alerts before scheduled time

### 5. Lock Screen Emergency ID
- **home_widget** for Android widget
- Public URL fallback: `app://emergency-id/{userId}`
- Displays blood type, allergies, conditions, emergency contacts

---

## Animation Strategy (NO FADING)

| Component | Animation |
|-----------|-----------|
| Page transitions | Slide from right (`easeOutCubic`) |
| Modals/dialogs | Scale from center (`elasticOut`) |
| List items | Staggered slide up + scale |
| Buttons | Bounce on press (`elasticOut`) |
| Cards | Scale on tap with spring physics |
| Emergency FAB | Continuous pulse + scale |
| Map markers | Drop bounce |
| Loading states | Shimmer (not fade) |

---

## Color Palette (Beige/Cozy)

| Role | Color | Hex |
|------|-------|-----|
| Primary | Warm Tan | `#D4A574` |
| Primary Light | Light Beige | `#E8C9A6` |
| Secondary | Terracotta | `#E07A5F` |
| Background | Warm Cream | `#FAF6F1` |
| Surface | Soft White | `#FFFBF7` |
| Text Primary | Warm Dark Gray | `#3D3D3D` |
| Success | Sage Green | `#81B29A` |
| Emergency | True Red | `#DC3545` |

---

## Implementation Order

### Phase 1: Foundation
1. Create Flutter project with proper structure
2. Set up Supabase project + database schema
3. Configure theme with beige palette
4. Implement auth flow (email/password)
5. Set up GoRouter with custom transitions

### Phase 2: Core Features
1. Family groups + memberships
2. Contact management
3. Document vault (upload/view/download)
4. Medical records + medications + appointments

### Phase 3: Real-time Features
1. Background location service
2. Family map with real-time updates
3. Emergency button + alert system
4. Push notifications (FCM)

### Phase 4: Polish
1. Medication/appointment reminders
2. Lock screen emergency ID
3. Offline support with Hive caching
4. Animation refinements

---

## Verification Plan

1. **Auth Flow**: Register, login, logout, password reset
2. **Family Groups**: Create group, generate invite code, join group, leave group
3. **Documents**: Upload PDF/image/doc, view, download, share with family
4. **Location**: Background updates visible on family map
5. **Emergency**: Trigger alert, verify push notification received on other device
6. **Reminders**: Set medication reminder, verify notification fires
7. **Animations**: All transitions slide/scale (no fading)

---

## Critical Files to Create First

1. `lib/core/config/supabase_config.dart` - Supabase initialization
2. `lib/core/theme/app_colors.dart` - Beige color palette
3. `lib/core/theme/app_theme.dart` - Rounded theme
4. `lib/core/router/app_router.dart` - Navigation with custom transitions
5. `lib/core/animations/spring_curves.dart` - Animation constants
6. `lib/shared/providers/supabase_provider.dart` - Global Supabase provider
