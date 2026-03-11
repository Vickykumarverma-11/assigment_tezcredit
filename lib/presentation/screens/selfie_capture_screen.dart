import 'dart:io';

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
    with ScreenshotPreventionMixin {
  late final CameraBloc _cameraBloc;

  @override
  void initState() {
    super.initState();
    _cameraBloc = sl<CameraBloc>();
    _cameraBloc.add(const CameraInitialized());
    initScreenshotPrevention();
  }

  @override
  void dispose() {
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
            appBar: AppBar(
              title: const Text('Selfie Capture'),
              centerTitle: true,
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocConsumer<CameraBloc, CameraState>(
                listener: (context, state) {
                  if (state is CameraError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CameraInitial) {
                    return const Center(child: CircularProgressIndicator());
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

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          if (showBlurOverlay) const BlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipOval(
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Position your face in the circle',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              FloatingActionButton.large(
                onPressed: () {
                  sl<SessionManager>().refreshSession();
                  _cameraBloc.add(const SelfieCaptured());
                },
                backgroundColor: Colors.blue.shade700,
                child: const Icon(
                  Icons.camera_alt,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipOval(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  sl<SessionManager>().refreshSession();
                  _cameraBloc.add(const SelfieRetaken());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retake'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              ElevatedButton.icon(
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
                icon: const Icon(Icons.check),
                label: const Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _cameraBloc.add(const CameraInitialized());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

}
