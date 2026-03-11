import 'dart:async';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';

typedef SessionExpiredCallback = void Function();

class SessionManager {
  Timer? _sessionTimer;
  SessionExpiredCallback? _onSessionExpired;
  bool _isSessionActive = false;

  /// Registers a callback to be invoked when the session expires.
  void setOnSessionExpired(SessionExpiredCallback callback) {
    _onSessionExpired = callback;
  }

  /// Starts a new session with the configured timeout.
  void startSession() {
    _isSessionActive = true;
    _resetTimer();
  }

  /// Refreshes the session timer. Call on every user interaction.
  void refreshSession() {
    if (_isSessionActive) {
      _resetTimer();
    }
  }

  /// Returns true if no active session or timer has fired.
  bool isSessionExpired() {
    return !_isSessionActive;
  }

  /// Ends the session and cancels the timer.
  void endSession() {
    _isSessionActive = false;
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  void _resetTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(
      const Duration(minutes: AppConstants.sessionTimeoutMinutes),
      _handleSessionExpired,
    );
  }

  void _handleSessionExpired() {
    _isSessionActive = false;
    _sessionTimer = null;
    _onSessionExpired?.call();
  }

  void dispose() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _onSessionExpired = null;
  }
}
