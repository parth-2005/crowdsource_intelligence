# 🚀 Quick Start Guide - CrowdPulse

## Run the App (3 Steps)

### 1️⃣ Install Dependencies
```bash
flutter pub get
```

### 2️⃣ Enable Platform (Choose One)
```bash
# For Android/iOS (if device connected)
flutter devices

# For Web
flutter config --enable-web

# For Windows
flutter config --enable-windows-desktop
```

### 3️⃣ Run
```bash
# Auto-detect device
flutter run

# Specific platform
flutter run -d chrome        # Web
flutter run -d windows       # Windows
flutter run -d <device-id>   # Android/iOS
```

---

## 📁 File Navigation

### Need to change colors/theme?
→ [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart)

### Need to adjust karma points or constants?
→ [`lib/core/constants/app_constants.dart`](lib/core/constants/app_constants.dart)

### Need to add more mock cards?
→ [`lib/data/repositories/mock_card_repository.dart`](lib/data/repositories/mock_card_repository.dart)

### Need to modify card swipe logic?
→ [`lib/logic/feed/feed_bloc.dart`](lib/logic/feed/feed_bloc.dart)

### Need to change UI layouts?
→ [`lib/presentation/widgets/`](lib/presentation/widgets/)

---

## 🎯 Key Commands

```bash
# Run app
flutter run

# Run with hot reload
flutter run --hot

# Build APK (Android)
flutter build apk --release

# Build for Web
flutter build web

# Check for errors
flutter analyze

# Run tests
flutter test

# Clean build
flutter clean
flutter pub get
```

---

## 🐛 Troubleshooting

### "No devices found"
```bash
# Enable web/desktop
flutter config --enable-web
flutter config --enable-windows-desktop

# Check available devices
flutter devices
```

### "Package not found"
```bash
flutter clean
flutter pub get
```

### "Build failed"
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 App Flow

```
Splash (3s) → Home Screen → Swipe Cards → Stats Reveal → Next Card
                              ↓              ↓
                         Karma Updates   Animations
```

---

## 🎨 Customization Quick Tips

### Change Primary Color
```dart
// lib/core/theme/app_theme.dart
static const Color primaryColor = Color(0xFF673AB7); // Change this
```

### Adjust Karma Points
```dart
// lib/core/constants/app_constants.dart
static const int baseKarmaPoints = 10;        // Per swipe
static const int goldenTicketReward = 50;     // Golden ticket
```

### Modify Animation Speed
```dart
// lib/core/constants/app_constants.dart
static const Duration cardSwipeDuration = Duration(milliseconds: 400);
static const Duration statsRevealDuration = Duration(milliseconds: 600);
```

### Add More Cards
```dart
// lib/data/repositories/mock_card_repository.dart
// Add to the list in fetchCards():
const CardModel(
  id: '8',
  type: CardType.BINARY,
  question: 'Your question here?',
  imageUrl: 'https://picsum.photos/400/600?random=8',
  stats: StatsData(yesPercent: 50, totalVotes: 1000),
),
```

---

## ✅ Verification Checklist

After running the app, verify:
- [ ] Splash screen shows for 3 seconds
- [ ] Cards load and display properly
- [ ] Swipe left/right works smoothly
- [ ] Haptic feedback occurs on swipe
- [ ] Stats overlay appears after swipe
- [ ] Pie chart animates correctly
- [ ] Golden Ticket shows confetti
- [ ] "NEXT" button resumes to next card
- [ ] Karma badge updates in app bar
- [ ] All 7 cards can be swiped

---

## 📚 Learn More

- **BLoC Pattern**: https://bloclibrary.dev/
- **Clean Architecture**: https://blog.cleancoder.com/
- **Flutter Docs**: https://docs.flutter.dev/

---

**Need help? Check [`IMPLEMENTATION_SUMMARY.md`](IMPLEMENTATION_SUMMARY.md) for detailed architecture!**
