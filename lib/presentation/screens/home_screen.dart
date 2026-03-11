import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/screenshot_prevention_service.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _carouselController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  bool _showBlurOverlay = false;

  final List<_CarouselItem> _carouselItems = const [
    _CarouselItem(
      title: 'Instant Personal Loans',
      subtitle: 'Get approved in minutes\nLoans up to \u20B910,00,000',
      gradient: [Color(0xFF1565C0), Color(0xFF0D47A1)],
      icon: Icons.bolt,
    ),
    _CarouselItem(
      title: 'Low Interest Rates',
      subtitle: 'Starting from 10.5% p.a.\nFlexible tenure options',
      gradient: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
      icon: Icons.trending_down,
    ),
    _CarouselItem(
      title: 'Quick Disbursement',
      subtitle: 'Direct to your bank account\nMinimal documentation',
      gradient: [Color(0xFFE65100), Color(0xFFBF360C)],
      icon: Icons.rocket_launch,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

    sl<ScreenshotPreventionService>().lifecycleStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _showBlurOverlay = state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused;
      });
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _carouselItems.length;
      _carouselController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  void _refreshSession() {
    sl<SessionManager>().refreshSession();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildCarousel(),
                const SizedBox(height: 8),
                _buildCarouselIndicator(),
                const SizedBox(height: 24),
                _buildLoanEligibilityCard(context),
                const SizedBox(height: 16),
                _buildEmiCalculatorCard(context),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (_showBlurOverlay) _buildBlurOverlay(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue.shade700,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          child: const Icon(Icons.person, color: Colors.white, size: 22),
        ),
      ),
      title: const Text(
        'TezCredit',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            _refreshSession();
          },
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _carouselController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemCount: _carouselItems.length,
        itemBuilder: (context, index) {
          final item = _carouselItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: item.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: item.gradient.first.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      item.icon,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _carouselItems.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? Colors.blue.shade700
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildLoanEligibilityCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          _refreshSession();
          context.go(AppConstants.applicantRoute);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You are eligible for a loan',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Up to \u20B910,00,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tap to start KYC verification',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmiCalculatorCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          _refreshSession();
          context.push(AppConstants.emiCalculatorRoute);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calculate,
                    color: Colors.orange.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calculate Your EMI',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Plan your loan repayment',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildQuickActionItem(
                icon: Icons.description,
                label: 'Apply\nLoan',
                color: Colors.blue,
                onTap: () {
                  _refreshSession();
                  context.go(AppConstants.applicantRoute);
                },
              ),
              const SizedBox(width: 12),
              _buildQuickActionItem(
                icon: Icons.calculate,
                label: 'EMI\nCalculator',
                color: Colors.orange,
                onTap: () {
                  _refreshSession();
                  context.push(AppConstants.emiCalculatorRoute);
                },
              ),
              const SizedBox(width: 12),
              _buildQuickActionItem(
                icon: Icons.verified_user,
                label: 'Check\nEligibility',
                color: Colors.green,
                onTap: () {
                  _refreshSession();
                  context.go(AppConstants.applicantRoute);
                },
              ),
              const SizedBox(width: 12),
              _buildQuickActionItem(
                icon: Icons.support_agent,
                label: 'Help\nCenter',
                color: Colors.purple,
                onTap: () {
                  _refreshSession();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: Colors.white.withValues(alpha: 0.8),
          child: const Center(
            child: Icon(Icons.lock, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _CarouselItem {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;

  const _CarouselItem({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });
}
