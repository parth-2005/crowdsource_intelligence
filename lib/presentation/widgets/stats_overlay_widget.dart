import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../data/models/stats_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class StatsOverlayWidget extends StatelessWidget {
  final StatsModel stats;
  final bool isMajority;
  final bool isGoldenTicket;
  final int? rewardPoints;
  final VoidCallback onNext;

  const StatsOverlayWidget({
    super.key,
    required this.stats,
    required this.isMajority,
    this.isGoldenTicket = false,
    this.rewardPoints,
    required this.onNext,
  });

  String _getBadgeText() {
    if (isGoldenTicket) {
      return AppConstants.goldenTicketTitle;
    }
    
    // Check for tight race (within 5% difference)
    final difference = (stats.yesPercent - stats.noPercent).abs();
    if (difference <= AppConstants.tightRaceThreshold) {
      return AppConstants.tightRaceBadge;
    }
    
    return isMajority ? AppConstants.majorityBadge : AppConstants.minorityBadge;
  }

  Color _getBadgeColor() {
    if (isGoldenTicket) {
      return AppConstants.goldenColor;
    }
    return isMajority ? AppTheme.successColor : AppTheme.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          // Confetti Animation for Golden Ticket
          if (isGoldenTicket)
            Positioned.fill(
              child: Lottie.network(
                'https://lottie.host/embed/e5987f34-41c1-4a12-ae70-2a5a7e56e501/hfm1RIuvqf.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Badge
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _getBadgeColor(),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _getBadgeColor().withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        _getBadgeText(),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isGoldenTicket ? Colors.black : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Reward Points (if applicable)
                  if (rewardPoints != null && rewardPoints! > 0)
                    FadeIn(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          Text(
                            '+${rewardPoints}',
                            style: GoogleFonts.poppins(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.goldenColor,
                            ),
                          ),
                          Text(
                            'KARMA POINTS',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  
                  // Pie Chart (only for non-golden tickets)
                  if (!isGoldenTicket)
                    ZoomIn(
                      duration: AppConstants.statsRevealDuration,
                      child: Container(
                        width: 280,
                        height: 280,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 60,
                            sections: [
                              PieChartSectionData(
                                color: AppConstants.yesColor,
                                value: stats.yesPercent.toDouble(),
                                title: '${stats.yesPercent}%',
                                radius: 80,
                                titleStyle: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: AppConstants.noColor,
                                value: stats.noPercent.toDouble(),
                                title: '${stats.noPercent}%',
                                radius: 80,
                                titleStyle: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 30),
                  
                  // Legend
                  if (!isGoldenTicket)
                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('YES', AppConstants.yesColor),
                          const SizedBox(width: 40),
                          _buildLegendItem('NO', AppConstants.noColor),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Total Votes
                  if (!isGoldenTicket)
                    FadeIn(
                      delay: const Duration(milliseconds: 1000),
                      child: Text(
                        '${stats.totalVotes.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )} votes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // Next Button
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        AppConstants.nextButtonText,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
