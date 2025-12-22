# 🚀 CrowdPulse - Gamified Crowd Intelligence App

<div align="center">
  <h3>Your Voice. Your Rewards.</h3>
  <p>Swipe, Vote, Earn - See what the world thinks in real-time!</p>
</div>

---

## 📱 Overview

**CrowdPulse** is a gamified MVP app built with Flutter that brings crowd intelligence to your fingertips. Users swipe through binary questions (Yes/No), see real-time statistics, and earn karma points for participating.

### ✨ Key Features

- 🎴 **Tinder-like Card Swiper**: Smooth, intuitive card interface
- 📊 **Real-time Stats**: Beautiful animated pie charts showing community opinion
- 🎟️ **Golden Tickets**: Special reward cards with confetti animations
- ⭐ **Karma Points System**: Gamified rewards for engagement
- 🎯 **Majority/Minority Badges**: See if you're with the crowd or standing out
- ⚖️ **Tight Race Detection**: Special badge for close polls (within 5%)
- 🎨 **Dark Theme**: Sleek UI with Deep Purple primary color and Poppins font

---

## 🏗️ Architecture

Built with **Clean Architecture** and **BLoC Pattern** for scalability and maintainability.

```
lib/
├── core/               # Theme, Constants, Shared Resources
├── data/               # Models & Repositories (Data Layer)
├── logic/              # BLoCs (Business Logic Layer)
└── presentation/       # Widgets & Screens (UI Layer)
```

### Tech Stack

- **State Management**: `flutter_bloc` + `equatable`
- **Dependency Injection**: `get_it`
- **UI Components**: `flutter_card_swiper`, `animate_do`, `lottie`, `fl_chart`
- **Typography**: `google_fonts` (Poppins)

---

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code with Flutter extensions

### Steps

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Enable platform support** (if needed)
   ```bash
   # For Windows
   flutter config --enable-windows-desktop
   
   # For Web
   flutter config --enable-web
   ```

3. **Run the app**
   ```bash
   # For connected device/emulator
   flutter run
   
   # For Chrome
   flutter run -d chrome
   
   # For Windows
   flutter run -d windows
   ```

---

## 📂 Project Structure Details

### Data Layer
- **Models**: `CardModel`, `StatsModel` with JSON serialization
- **Repository Interface**: `ICardRepository` for abstraction
- **Mock Repository**: `MockCardRepository` with 800ms delay simulation

### Logic Layer (BLoCs)
- **FeedBloc**: Manages card stack, swipe logic, and stats reveal
  - Events: `LoadFeed`, `SwipeCard`, `ResumeFeed`
  - States: `FeedLoading`, `FeedLoaded`, `StatsReveal`, `FeedError`
  
- **UserBloc**: Handles karma points and gamification
  - Events: `AddKarmaPoints`, `ResetKarma`
  - State: `UserState` with `karmaPoints` and `totalSwipes`

### Presentation Layer
- **Widgets**:
  - `CardViewWidget`: Individual card UI with gradient overlay
  - `StatsOverlayWidget`: Animated stats reveal with pie chart
  - `KarmaBadge`: Animated score counter in app bar

- **Screens**:
  - `SplashScreen`: Animated intro with app logo
  - `HomeScreen`: Main feed with card stack and BLoC integration

---

## 🎮 How It Works

1. **Swipe Cards**: Users swipe right for YES, left for NO
2. **Freeze & Reveal**: On swipe, the UI freezes and shows animated stats
3. **Earn Karma**: 
   - Base: 10 points per swipe
   - Golden Ticket: 50 points
   - Majority bonus: +5 points
   - Minority bonus: +15 points (for unique perspectives!)
4. **Resume Feed**: Click "NEXT" to continue to the next card
5. **Special Features**:
   - Golden Tickets trigger confetti animations
   - Tight races (within 5%) get special badges
   - Haptic feedback on every swipe

---

## 🎨 Mock Data

The app includes 7 pre-populated cards:

1. "Is pineapple on pizza a crime?" (68% Yes)
2. "Should AI have rights?" (42% Yes)
3. **🎟️ GOLDEN TICKET** (50 bonus points)
4. "Does social media improve mental health?" (23% Yes)
5. "Is working from home more productive?" (49% Yes - **Tight Race!**)
6. 💼 **SPONSORED**: "Would you try an eco-friendly product?" (81% Yes)
7. "Is breakfast the most important meal?" (72% Yes)

---

## 🔧 Configuration

### Theme Customization
Edit `lib/core/theme/app_theme.dart`:
- Primary Color: `#673AB7` (Deep Purple)
- Accent Color: `#FFD700` (Gold)
- Background: `#121212` (Dark)

### Constants
Edit `lib/core/constants/app_constants.dart`:
- Karma point values
- Animation durations
- Tight race threshold
- API endpoints (for future backend)

---

## 📱 Platform Support

- ✅ **Android** (Primary)
- ✅ **iOS** (Primary)
- ⚙️ **Web** (Enable with `flutter config --enable-web`)
- ⚙️ **Windows** (Enable with `flutter config --enable-windows-desktop`)

---

## 🔮 Future Enhancements

- Backend API integration (replace `MockCardRepository`)
- User authentication & profiles
- Leaderboards & social features
- Custom card creation by users
- Push notifications for new cards
- Analytics dashboard
- Multi-language support
- Accessibility improvements

---

**Happy Swiping! 🎴✨**

## Getting Started (Original Flutter Docs)

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
