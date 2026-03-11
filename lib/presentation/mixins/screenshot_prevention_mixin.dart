import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/screenshot_prevention_service.dart';

/// Mixin that manages the blur overlay subscription lifecycle.
/// Screens using this mixin must call [initScreenshotPrevention] in initState
/// and [disposeScreenshotPrevention] in dispose.
mixin ScreenshotPreventionMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<AppLifecycleState>? _lifecycleSubscription;
  bool showBlurOverlay = false;

  void initScreenshotPrevention() {
    _lifecycleSubscription =
        sl<ScreenshotPreventionService>().lifecycleStream.listen((state) {
      if (!mounted) return;
      setState(() {
        showBlurOverlay = state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused;
      });
    });
  }

  void disposeScreenshotPrevention() {
    _lifecycleSubscription?.cancel();
    _lifecycleSubscription = null;
  }
}
