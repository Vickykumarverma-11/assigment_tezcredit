import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/presentation/bloc/camera_bloc.dart';
import 'package:assigment_tezcredit/presentation/mixins/screenshot_prevention_mixin.dart';
import 'package:assigment_tezcredit/presentation/widgets/blur_overlay.dart';

class SelfieCaptureScreen extends StatefulWidget {
  final ApplicantModel applicant;

  const SelfieCaptureScreen({super.key, required this.applicant});

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen>
    with TickerProviderStateMixin, ScreenshotPreventionMixin {
  late final CameraBloc _cameraBloc;
  late final AnimationController _pulseController;
  late final AnimationController _scanController;
  late final AnimationController _fadeController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _scanAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cameraBloc = sl<CameraBloc>();
    _cameraBloc.add(const CameraInitialized());
    initScreenshotPrevention();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    _fadeController.dispose();
    disposeScreenshotPrevention();
    _cameraBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cameraBloc,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xFF0A0E21),
            body: SafeArea(
              child: BlocConsumer<CameraBloc, CameraState>(
                listener: (context, state) {
                  if (state is CameraError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CameraInitial) {
                    return _buildLoadingView();
                  }
                  if (state is CameraReady) {
                    return _buildCameraPreview(state.controller);
                  }
                  if (state is SelfieCapturedState) {
                    return _buildImagePreview(state.path);
                  }
                  if (state is CameraError) {
                    return _buildErrorView(state.message);
                  }
                  return _buildLoadingView();
                },
              ),
            ),
          ),
          if (showBlurOverlay) const BlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopBar({bool showBack = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          const Spacer(),
          _buildStepIndicator(),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepDot(true),
          _buildStepLine(true),
          _buildStepDot(true),
          _buildStepLine(false),
          _buildStepDot(false),
        ],
      ),
    );
  }

  Widget _buildStepDot(bool completed) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? Colors.blue.shade400 : Colors.white.withValues(alpha: 0.3),
        border: completed
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
      ),
      child: completed
          ? const Icon(Icons.check, size: 7, color: Colors.white)
          : null,
    );
  }

  Widget _buildStepLine(bool completed) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: completed
          ? Colors.blue.shade400
          : Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      children: [
        _buildTopBar(showBack: false),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 24),
                Text(
                  'Initializing Camera...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    final size = MediaQuery.of(context).size;
    final frameSize = size.width * 0.7;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 8),
          const Text(
            'Selfie Verification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Step 2 of 3',
            style: TextStyle(
              color: Colors.blue.shade300,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Camera frame
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: frameSize + 20,
                  height: frameSize + 20,
                  child: CustomPaint(
                    painter: _FaceFramePainter(
                      progress: _scanAnimation.value,
                      pulseScale: _pulseAnimation.value,
                      color: Colors.blue.shade400,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: frameSize,
                        height: frameSize,
                        child: ClipOval(
                          child: CameraPreview(controller),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          // Instructions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: Colors.blue.shade300,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tips for a good selfie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Good lighting  •  Face the camera  •  Remove glasses',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Capture button
          GestureDetector(
            onTap: () {
              sl<SessionManager>().refreshSession();
              _cameraBloc.add(const SelfieCaptured());
            },
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade400.withValues(alpha: 0.4),
                        blurRadius: 20 * _pulseAnimation.value,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade700,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    final size = MediaQuery.of(context).size;
    final frameSize = size.width * 0.65;

    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 8),
        const Text(
          'Looking Good!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Review your selfie before continuing',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        // Image with success frame
        Center(
          child: Container(
            width: frameSize + 16,
            height: frameSize + 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green.shade400,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade400.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ClipOval(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  width: frameSize,
                  height: frameSize,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Verified badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade400.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.green.shade400.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade400, size: 18),
              const SizedBox(width: 6),
              Text(
                'Selfie Captured',
                style: TextStyle(
                  color: Colors.green.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Action buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    sl<SessionManager>().refreshSession();
                    _cameraBloc.add(const SelfieRetaken());
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Retake'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    sl<SessionManager>().refreshSession();
                    final updatedApplicant = widget.applicant.copyWith(
                      selfiePath: imagePath,
                    );
                    context.go(
                      AppConstants.resultRoute,
                      extra: updatedApplicant,
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: const Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Camera Error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      _cameraBloc.add(const CameraInitialized());
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the animated face frame
class _FaceFramePainter extends CustomPainter {
  final double progress;
  final double pulseScale;
  final Color color;

  _FaceFramePainter({
    required this.progress,
    required this.pulseScale,
    required this.color,
  }) : super(repaint: Listenable.merge([]));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;

    // Outer dashed ring
    final dashedPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashCount = 40;
    const dashAngle = (2 * math.pi) / dashCount;
    const gapRatio = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      const sweepAngle = dashAngle * (1 - gapRatio);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + 6),
        startAngle,
        sweepAngle,
        false,
        dashedPaint,
      );
    }

    // Scanning arc
    final scanPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final scanAngle = progress * 2 * math.pi;
    const sweepLength = math.pi / 2;

    scanPaint.shader = SweepGradient(
      startAngle: scanAngle,
      endAngle: scanAngle + sweepLength,
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.8),
      ],
      stops: const [0.0, 1.0],
      transform: GradientRotation(scanAngle),
    ).createShader(
      Rect.fromCircle(center: center, radius: radius + 6),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 6),
      scanAngle,
      sweepLength,
      false,
      scanPaint,
    );

    // Corner brackets
    final bracketPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const bracketLength = 0.3;
    final positions = [0.0, math.pi / 2, math.pi, 3 * math.pi / 2];
    for (final pos in positions) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + 2),
        pos - bracketLength / 2,
        bracketLength,
        false,
        bracketPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_FaceFramePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseScale != pulseScale;
  }
}
