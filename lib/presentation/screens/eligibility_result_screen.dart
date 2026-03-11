import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/screenshot_prevention_service.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/presentation/bloc/eligibility_bloc.dart';

class EligibilityResultScreen extends StatefulWidget {
  final ApplicantModel applicant;

  const EligibilityResultScreen({super.key, required this.applicant});

  @override
  State<EligibilityResultScreen> createState() =>
      _EligibilityResultScreenState();
}

class _EligibilityResultScreenState extends State<EligibilityResultScreen> {
  late final EligibilityBloc _eligibilityBloc;
  bool _showBlurOverlay = false;

  @override
  void initState() {
    super.initState();
    _eligibilityBloc = sl<EligibilityBloc>();
    _eligibilityBloc.add(EvaluateEligibility(applicant: widget.applicant));

    sl<ScreenshotPreventionService>().lifecycleStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _showBlurOverlay = state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused;
      });
    });
  }

  @override
  void dispose() {
    _eligibilityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eligibilityBloc,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Eligibility Result'),
              centerTitle: true,
              elevation: 0,
            ),
            body: SafeArea(
              child: BlocBuilder<EligibilityBloc, EligibilityState>(
                builder: (context, state) {
                  if (state is EligibilityLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is EligibilitySuccess) {
                    return _buildResult(context, state);
                  }

                  if (state is EligibilityFailure) {
                    return _buildError(context, state.message);
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          if (_showBlurOverlay) _buildBlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, EligibilitySuccess state) {
    final result = state.result;
    final isApproved = result.isApproved;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Status Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isApproved ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isApproved ? Icons.check_circle : Icons.cancel,
              size: 64,
              color: isApproved ? Colors.green.shade600 : Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isApproved ? 'Approved' : 'Rejected',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isApproved ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 32),

          // Details Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Eligible Loan Amount',
                    '\u20B9${result.eligibleAmount.toStringAsFixed(2)}',
                    Icons.account_balance,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Estimated EMI',
                    '\u20B9${result.estimatedEmi.toStringAsFixed(2)}',
                    Icons.calendar_month,
                  ),
                ],
              ),
            ),
          ),

          // Rejection Reasons
          if (!isApproved && result.rejectionReasons.isNotEmpty) ...[
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Rejection Reasons',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...result.rejectionReasons.map(
                      (reason) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red.shade600,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                reason,
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // EMI Calculator Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                sl<SessionManager>().refreshSession();
                context.push(AppConstants.emiCalculatorRoute);
              },
              icon: const Icon(Icons.calculate),
              label: const Text(
                'EMI Calculator',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _eligibilityBloc.add(
                  EvaluateEligibility(applicant: widget.applicant),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: Colors.white.withValues(alpha: 0.8),
          child: const Center(
            child: Icon(Icons.lock, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
