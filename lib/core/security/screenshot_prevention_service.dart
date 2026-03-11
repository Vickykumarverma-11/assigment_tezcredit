import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';

class ScreenshotPreventionService with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel(
    AppConstants.screenshotPreventionChannel,
  );

  final StreamController<AppLifecycleState> _lifecycleController =
      StreamController<AppLifecycleState>.broadcast();

  /// Stream of lifecycle state changes for iOS blur overlay logic.
  Stream<AppLifecycleState> get lifecycleStream => _lifecycleController.stream;

  bool _isObserving = false;

  /// Initializes screenshot prevention.
  /// Android: calls platform channel to set FLAG_SECURE.
  /// iOS: starts lifecycle observer for blur overlay.
  Future<void> init() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('enableScreenshotPrevention');
      } on PlatformException catch (_) {
        // Platform channel not available — silently continue
      }
    }

    if (!_isObserving) {
      WidgetsBinding.instance.addObserver(this);
      _isObserving = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleController.add(state);
  }

  /// Disables screenshot prevention (e.g. for debugging).
  Future<void> disable() async {
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('disableScreenshotPrevention');
      } on PlatformException catch (_) {
        // Platform channel not available — silently continue
      }
    }
  }

  /// Cleans up the lifecycle observer and stream controller.
  void dispose() {
    if (_isObserving) {
      WidgetsBinding.instance.removeObserver(this);
      _isObserving = false;
    }
    _lifecycleController.close();
  }
}
