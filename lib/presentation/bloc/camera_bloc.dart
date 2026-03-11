import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Events ───────────────────────────────────────────────

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class CameraInitialized extends CameraEvent {
  const CameraInitialized();
}

class SelfieCaptured extends CameraEvent {
  const SelfieCaptured();
}

class SelfieRetaken extends CameraEvent {
  const SelfieRetaken();
}

// ─── States ───────────────────────────────────────────────

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraReady extends CameraState {
  final CameraController controller;

  const CameraReady({required this.controller});

  @override
  List<Object?> get props => [controller];
}

class SelfieCapturedState extends CameraState {
  final String path;

  const SelfieCapturedState({required this.path});

  @override
  List<Object?> get props => [path];
}

class CameraError extends CameraState {
  final String message;

  const CameraError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── Bloc ─────────────────────────────────────────────────

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? _controller;

  CameraBloc() : super(const CameraInitial()) {
    on<CameraInitialized>(_onCameraInitialized);
    on<SelfieCaptured>(_onSelfieCaptured);
    on<SelfieRetaken>(_onSelfieRetaken);
  }

  Future<void> _onCameraInitialized(
    CameraInitialized event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        emit(const CameraError(message: 'No cameras available'));
        return;
      }

      // Prefer front camera for selfie
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      emit(CameraReady(controller: _controller!));
    } catch (e) {
      emit(CameraError(message: 'Failed to initialize camera: $e'));
    }
  }

  Future<void> _onSelfieCaptured(
    SelfieCaptured event,
    Emitter<CameraState> emit,
  ) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      emit(const CameraError(message: 'Camera not initialized'));
      return;
    }

    try {
      final image = await _controller!.takePicture();
      emit(SelfieCapturedState(path: image.path));
    } catch (e) {
      emit(CameraError(message: 'Failed to capture selfie: $e'));
    }
  }

  Future<void> _onSelfieRetaken(
    SelfieRetaken event,
    Emitter<CameraState> emit,
  ) async {
    if (_controller != null && _controller!.value.isInitialized) {
      emit(CameraReady(controller: _controller!));
    } else {
      add(const CameraInitialized());
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
