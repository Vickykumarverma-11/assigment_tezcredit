import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/screenshot_prevention_service.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/presentation/screens/applicant_details_screen.dart';
import 'package:assigment_tezcredit/presentation/screens/biometric_auth_screen.dart';
import 'package:assigment_tezcredit/presentation/screens/home_screen.dart';
import 'package:assigment_tezcredit/presentation/screens/eligibility_result_screen.dart';
import 'package:assigment_tezcredit/presentation/screens/emi_calculator_screen.dart';
import 'package:assigment_tezcredit/presentation/screens/selfie_capture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize all dependencies (security services init before any screen)
  await initDependencies();

  // Initialize screenshot prevention
  await sl<ScreenshotPreventionService>().init();

  runApp(const TezCreditApp());
}

final GoRouter _router = GoRouter(
  initialLocation: AppConstants.biometricAuthRoute,
  redirect: (context, state) {
    final sessionManager = sl<SessionManager>();
    if (sessionManager.isSessionExpired() &&
        state.uri.path != AppConstants.biometricAuthRoute) {
      return AppConstants.biometricAuthRoute;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppConstants.biometricAuthRoute,
      builder: (context, state) => const BiometricAuthScreen(),
    ),
    GoRoute(
      path: AppConstants.homeRoute,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppConstants.applicantRoute,
      builder: (context, state) => const ApplicantDetailsScreen(),
    ),
    GoRoute(
      path: AppConstants.selfieRoute,
      builder: (context, state) {
        final applicant = state.extra as ApplicantModel;
        return SelfieCaptureScreen(applicant: applicant);
      },
    ),
    GoRoute(
      path: AppConstants.resultRoute,
      builder: (context, state) {
        final applicant = state.extra as ApplicantModel;
        return EligibilityResultScreen(applicant: applicant);
      },
    ),
    GoRoute(
      path: AppConstants.emiCalculatorRoute,
      builder: (context, state) => const EmiCalculatorScreen(),
    ),
  ],
);

class TezCreditApp extends StatelessWidget {
  const TezCreditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
