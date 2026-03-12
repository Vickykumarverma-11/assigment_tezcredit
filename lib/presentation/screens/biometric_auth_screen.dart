import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/presentation/bloc/security_bloc.dart';
import 'package:assigment_tezcredit/presentation/mixins/screenshot_prevention_mixin.dart';
import 'package:assigment_tezcredit/presentation/widgets/blur_overlay.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with ScreenshotPreventionMixin {
  late final SecurityBloc _securityBloc;

  @override
  void initState() {
    super.initState();
    _securityBloc = sl<SecurityBloc>();
    _securityBloc.add(const AppLaunched());
    initScreenshotPrevention();
  }

  @override
  void dispose() {
    disposeScreenshotPrevention();
    _securityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _securityBloc,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: BlocConsumer<SecurityBloc, SecurityState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    context.go(AppConstants.homeRoute);
                  }
                  if (state is DeviceCompromised) {
                    _showDeviceCompromisedDialog(context, state.reason);
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              size: 48,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Authenticate to Continue',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 48),
                          _buildStateContent(context, state),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (showBlurOverlay) const BlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, SecurityState state) {
    if (state is DeviceCheckInProgress) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Checking device security...'),
        ],
      );
    }

    if (state is LockedOut) {
      return Column(
        children: [
          Icon(Icons.timer, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Too many failed attempts',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try again in ${state.secondsRemaining} seconds',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade400,
            ),
          ),
        ],
      );
    }

    if (state is AuthFailedState) {
      return Column(
        children: [
          Icon(Icons.fingerprint, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Authentication Failed',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Attempt ${state.attempts} of ${AppConstants.maxBiometricAttempts}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _securityBloc.add(const BiometricAuthenticated());
            },
            icon: const Icon(Icons.fingerprint),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      );
    }

    if (state is SecurityInitial) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Initializing...'),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _showDeviceCompromisedDialog(BuildContext context, String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
              const SizedBox(width: 8),
              const Text('Security Alert'),
            ],
          ),
          content: Text(
            'This device has been identified as compromised.\n\n'
            'Reason: $reason\n\n'
            'For security reasons, this app cannot be used on this device.',
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

}
