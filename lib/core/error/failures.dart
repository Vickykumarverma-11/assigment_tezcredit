import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class LocalDataFailure extends Failure {
  const LocalDataFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class CameraFailure extends Failure {
  const CameraFailure(super.message);
}

class BiometricFailure extends Failure {
  const BiometricFailure(super.message);
}

class RootDetectionFailure extends Failure {
  const RootDetectionFailure(super.message);
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure(super.message);
}

class CertificatePinningFailure extends Failure {
  const CertificatePinningFailure(super.message);
}

class EncryptionFailure extends Failure {
  const EncryptionFailure(super.message);
}

class DeviceFingerprintFailure extends Failure {
  const DeviceFingerprintFailure(super.message);
}
