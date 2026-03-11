import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/security/biometric_service.dart';
import 'package:assigment_tezcredit/core/security/root_detection_service.dart';
import 'package:assigment_tezcredit/core/security/security_service.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';

// ─── Events ───────────────────────────────────────────────

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

class AppLaunched extends SecurityEvent {
  const AppLaunched();
}

class BiometricAuthenticated extends SecurityEvent {
  const BiometricAuthenticated();
}

class AuthFailed extends SecurityEvent {
  const AuthFailed();
}

class SessionExpired extends SecurityEvent {
  const SessionExpired();
}

class SessionRefreshed extends SecurityEvent {
  const SessionRefreshed();
}

class DeviceCheckFailed extends SecurityEvent {
  const DeviceCheckFailed();
}

class _LockoutTick extends SecurityEvent {
  final int secondsRemaining;

  const _LockoutTick({required this.secondsRemaining});

  @override
  List<Object?> get props => [secondsRemaining];
}

// ─── States ───────────────────────────────────────────────

abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object?> get props => [];
}

class SecurityInitial extends SecurityState {
  const SecurityInitial();
}

class DeviceCheckInProgress extends SecurityState {
  const DeviceCheckInProgress();
}

class DeviceCompromised extends SecurityState {
  final String reason;

  const DeviceCompromised({required this.reason});

  @override
  List<Object?> get props => [reason];
}

class Authenticated extends SecurityState {
  const Authenticated();
}

class AuthFailedState extends SecurityState {
  final int attempts;

  const AuthFailedState({required this.attempts});

  @override
  List<Object?> get props => [attempts];
}

class LockedOut extends SecurityState {
  final int secondsRemaining;

  const LockedOut({required this.secondsRemaining});

  @override
  List<Object?> get props => [secondsRemaining];
}

class SessionExpiredState extends SecurityState {
  const SessionExpiredState();
}

// ─── Bloc ─────────────────────────────────────────────────

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final BiometricService _biometricService;
  final RootDetectionService _rootDetectionService;
  final SecurityService _securityService;
  final SessionManager _sessionManager;

  int _failedAttempts = 0;
  Timer? _lockoutTimer;

  SecurityBloc({
    required BiometricService biometricService,
    required RootDetectionService rootDetectionService,
    required SecurityService securityService,
    required SessionManager sessionManager,
  })  : _biometricService = biometricService,
        _rootDetectionService = rootDetectionService,
        _securityService = securityService,
        _sessionManager = sessionManager,
        super(const SecurityInitial()) {
    on<AppLaunched>(_onAppLaunched);
    on<BiometricAuthenticated>(_onBiometricAuthenticated);
    on<AuthFailed>(_onAuthFailed);
    on<SessionExpired>(_onSessionExpired);
    on<SessionRefreshed>(_onSessionRefreshed);
    on<DeviceCheckFailed>(_onDeviceCheckFailed);
    on<_LockoutTick>(_onLockoutTick);

    _sessionManager.setOnSessionExpired(() {
      add(const SessionExpired());
    });
  }

  Future<void> _onAppLaunched(
    AppLaunched event,
    Emitter<SecurityState> emit,
  ) async {
    emit(const DeviceCheckInProgress());

    // Check root / jailbreak
    final isRooted = await _rootDetectionService.isDeviceRooted();
    if (isRooted) {
      emit(const DeviceCompromised(reason: 'Device is rooted or jailbroken'));
      return;
    }

    // Verify device fingerprint
    final isTrustedDevice = await _securityService.verifyDeviceFingerprint();
    if (!isTrustedDevice) {
      emit(const DeviceCompromised(reason: 'Device fingerprint mismatch'));
      return;
    }

    // Device is clean — trigger biometric auth
    final authenticated = await _biometricService.authenticate();
    if (authenticated) {
      _failedAttempts = 0;
      _sessionManager.startSession();
      emit(const Authenticated());
    } else {
      _failedAttempts = 1;
      emit(AuthFailedState(attempts: _failedAttempts));
    }
  }

  Future<void> _onBiometricAuthenticated(
    BiometricAuthenticated event,
    Emitter<SecurityState> emit,
  ) async {
    final authenticated = await _biometricService.authenticate();
    if (authenticated) {
      _failedAttempts = 0;
      _sessionManager.startSession();
      emit(const Authenticated());
    } else {
      add(const AuthFailed());
    }
  }

  void _onAuthFailed(
    AuthFailed event,
    Emitter<SecurityState> emit,
  ) {
    _failedAttempts++;

    if (_failedAttempts >= AppConstants.maxBiometricAttempts) {
      _startLockout(emit);
    } else {
      emit(AuthFailedState(attempts: _failedAttempts));
    }
  }

  void _startLockout(Emitter<SecurityState> emit) {
    int remaining = AppConstants.lockoutDurationSeconds;
    emit(LockedOut(secondsRemaining: remaining));

    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        remaining--;
        if (remaining <= 0) {
          timer.cancel();
          _failedAttempts = 0;
          add(const AppLaunched());
        } else {
          add(_LockoutTick(secondsRemaining: remaining));
        }
      },
    );
  }

  void _onLockoutTick(
    _LockoutTick event,
    Emitter<SecurityState> emit,
  ) {
    emit(LockedOut(secondsRemaining: event.secondsRemaining));
  }

  void _onSessionExpired(
    SessionExpired event,
    Emitter<SecurityState> emit,
  ) {
    _sessionManager.endSession();
    emit(const SessionExpiredState());
  }

  void _onSessionRefreshed(
    SessionRefreshed event,
    Emitter<SecurityState> emit,
  ) {
    _sessionManager.refreshSession();
  }

  void _onDeviceCheckFailed(
    DeviceCheckFailed event,
    Emitter<SecurityState> emit,
  ) {
    emit(const DeviceCompromised(reason: 'Device security check failed'));
  }

  @override
  Future<void> close() {
    _lockoutTimer?.cancel();
    _sessionManager.dispose();
    return super.close();
  }
}
