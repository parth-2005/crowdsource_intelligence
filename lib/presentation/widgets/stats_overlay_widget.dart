import 'dart:math' as math;
import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (isGoldenTicket) return AppConstants.goldenTicketTitle;
    final difference = (stats.yesPercent - stats.noPercent).abs();
    if (difference <= AppConstants.tightRaceThreshold) {
      return AppConstants.tightRaceBadge;
    }
    return isMajority ? AppConstants.majorityBadge : AppConstants.minorityBadge;
  }

  Color _getBadgeColor() {
    if (isGoldenTicket) return AppConstants.goldenColor;
    return isMajority ? AppTheme.successColor : AppTheme.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Frosted Glass Background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.85), // Slightly more transparent
            ),
          ),
        ),

        // 2. Golden Ticket Animation (Behind content)
        if (isGoldenTicket) Positioned.fill(child: _GoldenTicketBackground()),

        // 3. Main Content
        SafeArea(
          child: Column(
            children: [
              // Scrollable Middle Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // BADGE
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: _getBadgeColor(),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: _getBadgeColor().withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            _getBadgeText(),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isGoldenTicket ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // REWARD POINTS (Or Error)
                      if (rewardPoints != null) ...[
                        FadeIn(
                          delay: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Text(
                                rewardPoints! > 0 ? '+$rewardPoints' : 'TOO FAST!',
                                style: GoogleFonts.poppins(
                                  fontSize: 56, // Slightly smaller to prevent overflow
                                  fontWeight: FontWeight.bold,
                                  color: rewardPoints! > 0 
                                      ? AppConstants.goldenColor 
                                      : AppTheme.errorColor,
                                ),
                              ),
                              Text(
                                rewardPoints! > 0 ? 'KARMA POINTS' : 'Read carefully to earn',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // PIE CHART
                      if (!isGoldenTicket) ...[
                        ZoomIn(
                          duration: AppConstants.statsRevealDuration,
                          child: SizedBox(
                            height: 250, // Fixed constrained height
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 50,
                                sections: [
                                  _buildSection(
                                    value: stats.yesPercent.toDouble(),
                                    color: AppConstants.yesColor,
                                    title: 'YES',
                                  ),
                                  _buildSection(
                                    value: stats.noPercent.toDouble(),
                                    color: AppConstants.noColor,
                                    title: 'NO',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Total Votes
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: Text(
                            '${stats.totalVotes} Total Votes',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // 4. Pinned Bottom Actions
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Quick Actions
                    if (!isGoldenTicket)
                      FadeInUp(
                        delay: const Duration(milliseconds: 800),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildActionButton(context, Icons.share_outlined, Colors.blueAccent),
                            _buildActionButton(context, Icons.flag_outlined, Colors.redAccent),
                            _buildActionButton(context, Icons.thumb_up_alt_outlined, Colors.greenAccent),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),

                    // Next Button
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            elevation: 8,
                            shadowColor: AppTheme.primaryColor.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper for Chart Sections to prevent text clutter
  PieChartSectionData _buildSection({required double value, required Color color, required String title}) {
    final isLarge = value > 15; // Only show text if slice is big enough
    return PieChartSectionData(
      color: color,
      value: value,
      title: isLarge ? '$title\n${value.toInt()}%' : '',
      radius: isLarge ? 80 : 70,
      titleStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2),
            color: color.withOpacity(0.1),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}

// Keep your _GoldenTicketBackground and _ConfettiPainter classes exactly as they were
// They were implemented correctly in your original code.
class _GoldenTicketBackground extends StatefulWidget {
  @override
  State<_GoldenTicketBackground> createState() => _GoldenTicketBackgroundState();
}

class _GoldenTicketBackgroundState extends State<_GoldenTicketBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Slowed down slightly
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  _ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 25; i++) {
      // Improved random-looking distribution
      final x = (i * size.width / 25 + math.sin(progress * 2 * math.pi + i) * 20) % size.width;
      final y = (progress * size.height * 1.5 + (i * 100)) % size.height;
      
      paint.color = i % 3 == 0 
          ? AppConstants.goldenColor.withOpacity(0.8)
          : Colors.white.withOpacity(0.4);
      
      canvas.drawCircle(Offset(x, y), 3 + (i % 4).toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}