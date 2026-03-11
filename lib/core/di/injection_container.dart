import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:assigment_tezcredit/core/security/biometric_service.dart';
import 'package:assigment_tezcredit/core/security/encryption_service.dart';
import 'package:assigment_tezcredit/core/security/root_detection_service.dart';
import 'package:assigment_tezcredit/core/security/screenshot_prevention_service.dart';
import 'package:assigment_tezcredit/core/security/security_service.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';
import 'package:assigment_tezcredit/core/security/ssl_pinning_interceptor.dart';
import 'package:assigment_tezcredit/data/datasources/loan_policy_local_datasource.dart';
import 'package:assigment_tezcredit/data/repositories/loan_repository_impl.dart';
import 'package:assigment_tezcredit/domain/repositories/loan_repository.dart';
import 'package:assigment_tezcredit/domain/usecases/evaluate_eligibility_usecase.dart';
import 'package:assigment_tezcredit/domain/usecases/load_loan_policy_usecase.dart';
import 'package:assigment_tezcredit/presentation/bloc/applicant_bloc.dart';
import 'package:assigment_tezcredit/presentation/bloc/camera_bloc.dart';
import 'package:assigment_tezcredit/presentation/bloc/eligibility_bloc.dart';
import 'package:assigment_tezcredit/presentation/bloc/emi_bloc.dart';
import 'package:assigment_tezcredit/presentation/bloc/security_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── External ─────────────────────────────────────────

  final dio = Dio();
  SslPinningInterceptor.attach(dio);
  sl.registerLazySingleton<Dio>(() => dio);

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());

  // ─── Security Services ────────────────────────────────

  final encryptionService = EncryptionService(
    secureStorage: sl<FlutterSecureStorage>(),
  );
  await encryptionService.init();
  sl.registerSingleton<EncryptionService>(encryptionService);

  sl.registerSingleton<BiometricService>(BiometricService());

  sl.registerSingleton<RootDetectionService>(RootDetectionService());

  sl.registerSingleton<ScreenshotPreventionService>(
    ScreenshotPreventionService(),
  );

  sl.registerSingleton<SessionManager>(SessionManager());

  sl.registerSingleton<SecurityService>(
    SecurityService(
      deviceInfo: sl<DeviceInfoPlugin>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  // ─── Data Sources ─────────────────────────────────────

  sl.registerLazySingleton<LoanPolicyLocalDatasource>(
    () => LoanPolicyLocalDatasourceImpl(),
  );

  // ─── Repositories ─────────────────────────────────────

  sl.registerLazySingleton<LoanRepository>(
    () => LoanRepositoryImpl(
      localDatasource: sl<LoanPolicyLocalDatasource>(),
    ),
  );

  // ─── Use Cases ────────────────────────────────────────

  sl.registerLazySingleton<LoadLoanPolicyUsecase>(
    () => LoadLoanPolicyUsecase(repository: sl<LoanRepository>()),
  );

  sl.registerLazySingleton<EvaluateEligibilityUsecase>(
    () => EvaluateEligibilityUsecase(repository: sl<LoanRepository>()),
  );

  // ─── Blocs (factories — new instance per request) ─────

  sl.registerFactory<SecurityBloc>(
    () => SecurityBloc(
      biometricService: sl<BiometricService>(),
      rootDetectionService: sl<RootDetectionService>(),
      securityService: sl<SecurityService>(),
      sessionManager: sl<SessionManager>(),
    ),
  );

  sl.registerFactory<ApplicantBloc>(
    () => ApplicantBloc(
      encryptionService: sl<EncryptionService>(),
    ),
  );

  sl.registerFactory<EligibilityBloc>(
    () => EligibilityBloc(
      evaluateEligibilityUsecase: sl<EvaluateEligibilityUsecase>(),
      loadLoanPolicyUsecase: sl<LoadLoanPolicyUsecase>(),
    ),
  );

  sl.registerFactory<CameraBloc>(() => CameraBloc());

  sl.registerFactory<EmiBloc>(() => EmiBloc());
}
