import 'dart:io';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';

class RootDetectionService {
  /// Checks if the device is rooted (Android) or jailbroken (iOS)
  /// by testing for the existence of known indicator file paths.
  /// Uses dart:io File only — no third-party package.
  Future<bool> isDeviceRooted() async {
    if (Platform.isAndroid) {
      return _checkPaths(AppConstants.androidRootPaths);
    } else if (Platform.isIOS) {
      return _checkPaths(AppConstants.iosJailbreakPaths);
    }
    return false;
  }

  Future<bool> _checkPaths(List<String> paths) async {
    for (final path in paths) {
      try {
        if (await File(path).exists()) {
          return true;
        }
      } catch (_) {
        // Permission denied or other error — skip this path
      }
    }
    return false;
  }
}
