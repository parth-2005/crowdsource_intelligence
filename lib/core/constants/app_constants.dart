import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'CrowdPulse';
  static const String appTagline = 'Your Voice. Your Rewards.';
  
  // Strings
  static const String loadingText = 'Loading cards...';
  static const String noMoreCardsText = 'No more cards! Check back later.';
  static const String errorText = 'Oops! Something went wrong.';
  static const String swipeLeft = 'Swipe Left for NO';
  static const String swipeRight = 'Swipe Right for YES';
  
  // Stats Overlay
  static const String majorityBadge = '🎯 You\'re with the majority!';
  static const String minorityBadge = '🦄 Unique perspective!';
  static const String tightRaceBadge = '⚖️ It\'s a tight race!';
  static const String goldenTicketTitle = '🎟️ GOLDEN TICKET!';
  static const String nextButtonText = 'NEXT';
  
  // Karma Points
  static const int baseKarmaPoints = 10;
  static const int majorityBonus = 5;
  static const int minorityBonus = 15;
  static const int goldenTicketReward = 50;
  
  // Animation Durations
  static const Duration cardSwipeDuration = Duration(milliseconds: 400);
  static const Duration statsRevealDuration = Duration(milliseconds: 600);
  static const Duration confettiDuration = Duration(seconds: 3);
  
  // Thresholds
  static const int tightRaceThreshold = 5; // If within 5% difference
  
  // Colors
  static const Color yesColor = Color(0xFF4CAF50);
  static const Color noColor = Color(0xFFE57373);
  static const Color goldenColor = Color(0xFFFFD700);
  
  // Asset Paths (for future use)
  static const String confettiLottie = 'assets/animations/confetti.json';
  static const String logoPath = 'assets/images/logo.png';
  
  // API (for future backend integration)
  static const String baseUrl = 'https://api.crowdpulse.com';
  static const Duration apiTimeout = Duration(seconds: 30);
}
