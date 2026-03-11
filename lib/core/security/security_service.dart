import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';

class SecurityService {
  final DeviceInfoPlugin _deviceInfo;
  final FlutterSecureStorage _secureStorage;

  SecurityService({
    required DeviceInfoPlugin deviceInfo,
    required FlutterSecureStorage secureStorage,
  })  : _deviceInfo = deviceInfo,
        _secureStorage = secureStorage;

  /// Collects device info, hashes it, and compares with the stored fingerprint.
  /// Returns true if fingerprints match or if this is the first launch.
  Future<bool> verifyDeviceFingerprint() async {
    final currentHash = await _computeFingerprint();
    final storedHash = await _secureStorage.read(
      key: AppConstants.deviceFingerprintKey,
    );

    if (storedHash == null) {
      await saveDeviceFingerprint();
      return true;
    }

    return currentHash == storedHash;
  }

  /// Computes and stores the device fingerprint in secure storage.
  Future<void> saveDeviceFingerprint() async {
    final hash = await _computeFingerprint();
    await _secureStorage.write(
      key: AppConstants.deviceFingerprintKey,
      value: hash,
    );
  }

  /// Collects device-specific attributes and returns a Map.
  Future<Map<String, String>> getDeviceInfo() async {
    final data = <String, String>{};

    if (Platform.isAndroid) {
      final android = await _deviceInfo.androidInfo;
      data['id'] = android.id;
      data['model'] = android.model;
      data['brand'] = android.brand;
      data['version'] = android.version.release;
    } else if (Platform.isIOS) {
      final ios = await _deviceInfo.iosInfo;
      data['id'] = ios.identifierForVendor ?? 'unknown';
      data['model'] = ios.model;
      data['version'] = ios.systemVersion;
    }

    return data;
  }

  Future<String> _computeFingerprint() async {
    final data = await getDeviceInfo();
    return _hashFingerprint(data);
  }

  String _hashFingerprint(Map<String, String> data) {
    final sortedKeys = data.keys.toList()..sort();
    final buffer = StringBuffer();
    for (final key in sortedKeys) {
      buffer.write('$key:${data[key]};');
    }
    final bytes = utf8.encode(buffer.toString());
    return sha256.convert(bytes).toString();
  }
}
