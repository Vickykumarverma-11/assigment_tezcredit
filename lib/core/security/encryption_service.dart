import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';

class EncryptionService {
  final FlutterSecureStorage _secureStorage;
  encrypt_pkg.Key? _key;

  EncryptionService({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  /// Loads the encryption key from secure storage, or generates and stores
  /// a new 32-byte key on first launch.
  Future<void> init() async {
    final storedKey = await _secureStorage.read(
      key: AppConstants.encryptionKeyStorageKey,
    );

    if (storedKey != null) {
      _key = encrypt_pkg.Key.fromBase64(storedKey);
    } else {
      final keyBytes = _generateRandomBytes(AppConstants.encryptionKeyLength);
      _key = encrypt_pkg.Key(keyBytes);
      await _secureStorage.write(
        key: AppConstants.encryptionKeyStorageKey,
        value: base64Encode(keyBytes),
      );
    }
  }

  /// Encrypts [plainText] using AES-256 CBC with a random IV.
  /// Returns base64(iv + ciphertext).
  String encryptData(String plainText) {
    _ensureInitialized();

    final iv = encrypt_pkg.IV.fromSecureRandom(16);
    final encrypter = encrypt_pkg.Encrypter(
      encrypt_pkg.AES(_key!, mode: encrypt_pkg.AESMode.cbc),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final combined = iv.bytes + encrypted.bytes;

    return base64Encode(combined);
  }

  /// Decrypts a base64-encoded string that contains iv (first 16 bytes)
  /// followed by the ciphertext.
  String decryptData(String encryptedBase64) {
    _ensureInitialized();

    final combined = base64Decode(encryptedBase64);
    final ivBytes = combined.sublist(0, 16);
    final cipherBytes = combined.sublist(16);

    final iv = encrypt_pkg.IV(ivBytes);
    final encrypted = encrypt_pkg.Encrypted(cipherBytes);
    final encrypter = encrypt_pkg.Encrypter(
      encrypt_pkg.AES(_key!, mode: encrypt_pkg.AESMode.cbc),
    );

    return encrypter.decrypt(encrypted, iv: iv);
  }

  void _ensureInitialized() {
    if (_key == null) {
      throw StateError(
        'EncryptionService not initialized. Call init() first.',
      );
    }
  }

  static Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }
}
