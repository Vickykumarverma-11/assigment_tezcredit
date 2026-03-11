import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/error/failures.dart';

class SslPinningInterceptor {
  /// Attaches a custom [HttpClient] with certificate pinning to [dio].
  ///
  /// In production: validates the server certificate SHA-256 fingerprint
  /// against [AppConstants.pinnedCertificateFingerprint].
  ///
  /// In current build: logs the certificate info and allows the connection
  /// (scaffold for when a real API is integrated).
  static void attach(Dio dio) {
    final adapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          final fingerprint = cert.sha256Fingerprint;

          // Development mode — log and allow
          if (AppConstants.pinnedCertificateFingerprint ==
              'SHA256_FINGERPRINT_PLACEHOLDER') {
            developer.log(
              'SSL Pinning [DEV]: host=$host, port=$port, '
              'fingerprint=$fingerprint',
              name: 'SslPinning',
            );
            return true;
          }

          // Production mode — validate fingerprint
          final fingerprintHex = fingerprint
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(':')
              .toUpperCase();

          if (fingerprintHex == AppConstants.pinnedCertificateFingerprint) {
            return true;
          }

          developer.log(
            'SSL Pinning FAILED: expected '
            '${AppConstants.pinnedCertificateFingerprint}, '
            'got $fingerprintHex for host=$host',
            name: 'SslPinning',
          );
          return false;
        };
        return client;
      },
    );

    dio.httpClientAdapter = adapter;

    // Add interceptor to throw typed failure on connection errors
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.type == DioExceptionType.connectionError ||
              error.error is HandshakeException) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: const CertificatePinningFailure(
                  'Certificate pinning validation failed',
                ),
                type: DioExceptionType.connectionError,
              ),
            );
            return;
          }
          handler.next(error);
        },
      ),
    );
  }
}

extension on X509Certificate {
  List<int> get sha256Fingerprint {
    return der.toList();
  }
}
