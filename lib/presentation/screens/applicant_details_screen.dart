import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/screenshot_prevention_service.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';
import 'package:assigment_tezcredit/core/utils/validators.dart';
import 'package:assigment_tezcredit/presentation/bloc/applicant_bloc.dart';

class ApplicantDetailsScreen extends StatefulWidget {
  const ApplicantDetailsScreen({super.key});

  @override
  State<ApplicantDetailsScreen> createState() => _ApplicantDetailsScreenState();
}

class _ApplicantDetailsScreenState extends State<ApplicantDetailsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _panController = TextEditingController();
  final _incomeController = TextEditingController();
  final _loanAmountController = TextEditingController();

  String _employmentType = AppConstants.employmentTypes.first;
  int _creditHistory = 1;
  bool _showBlurOverlay = false;

  late final ApplicantBloc _applicantBloc;
  late final SessionManager _sessionManager;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _applicantBloc = sl<ApplicantBloc>();
    _sessionManager = sl<SessionManager>();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();

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
    _nameController.dispose();
    _panController.dispose();
    _incomeController.dispose();
    _loanAmountController.dispose();
    _applicantBloc.close();
    _animController.dispose();
    super.dispose();
  }

  void _refreshSession() {
    _sessionManager.refreshSession();
  }

  void _onFieldChanged() {
    _refreshSession();
  }

  void _onSubmit() {
    _refreshSession();
    _applicantBloc.add(ApplicantFormSubmitted(
      fullName: _nameController.text,
      panNumber: _panController.text,
      monthlyIncome: _incomeController.text,
      requestedLoanAmount: _loanAmountController.text,
      employmentType: _employmentType,
      creditHistory: _creditHistory,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _applicantBloc,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SafeArea(
              child: BlocConsumer<ApplicantBloc, ApplicantState>(
                listener: (context, state) {
                  if (state is ApplicantValid) {
                    context.go(
                      AppConstants.selfieRoute,
                      extra: state.applicant,
                    );
                  }
                  if (state is ApplicantInvalid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please fill all fields correctly'),
                        backgroundColor: Colors.red.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final errors =
                      state is ApplicantInvalid ? state.errors : null;

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: CustomScrollView(
                        slivers: [
                          _buildSliverAppBar(),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              child: Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 8),
                                    _buildProgressIndicator(),
                                    const SizedBox(height: 20),
                                    _buildSectionCard(
                                      title: 'Personal Information',
                                      icon: Icons.person_outline,
                                      children: [
                                        _buildNameField(errors),
                                        const SizedBox(height: 16),
                                        _buildPanField(errors),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildSectionCard(
                                      title: 'Financial Details',
                                      icon: Icons.account_balance_wallet,
                                      children: [
                                        _buildIncomeField(errors),
                                        const SizedBox(height: 16),
                                        _buildLoanAmountField(errors),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildSectionCard(
                                      title: 'Employment & Credit',
                                      icon: Icons.work_outline,
                                      children: [
                                        _buildEmploymentDropdown(),
                                        const SizedBox(height: 20),
                                        _buildCreditHistoryToggle(),
                                      ],
                                    ),
                                    const SizedBox(height: 28),
                                    _buildSubmitButton(),
                                    const SizedBox(height: 12),
                                    _buildSecurityNote(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_showBlurOverlay) _buildBlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Colors.blue.shade700,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go(AppConstants.homeRoute),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Icon(
                Icons.verified_user,
                size: 48,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        children: [
          _buildStep(1, 'Details', true),
          _buildStepConnector(false),
          _buildStep(2, 'Selfie', false),
          _buildStepConnector(false),
          _buildStep(3, 'Result', false),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue.shade700 : Colors.grey.shade300,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? Colors.blue.shade700 : Colors.grey.shade500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isCompleted) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 2,
          color: isCompleted ? Colors.blue.shade700 : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue.shade700, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: Icon(icon, color: Colors.blue.shade400),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildNameField(Map<String, String>? errors) {
    return TextFormField(
      controller: _nameController,
      decoration: _buildInputDecoration(
        label: 'Full Name',
        icon: Icons.person_outline,
        errorText: errors?['fullName'],
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      onChanged: (_) => _onFieldChanged(),
    );
  }

  Widget _buildPanField(Map<String, String>? errors) {
    return TextFormField(
      controller: _panController,
      decoration: _buildInputDecoration(
        label: 'PAN Number',
        icon: Icons.credit_card,
        hint: 'ABCDE1234F',
        errorText: errors?['panNumber'],
      ),
      textCapitalization: TextCapitalization.characters,
      onChanged: (value) {
        final sanitized = Validators.sanitizePan(value);
        if (sanitized != value) {
          _panController.value = TextEditingValue(
            text: sanitized,
            selection: TextSelection.collapsed(offset: sanitized.length),
          );
        }
        _onFieldChanged();
      },
    );
  }

  Widget _buildIncomeField(Map<String, String>? errors) {
    return TextFormField(
      controller: _incomeController,
      decoration: _buildInputDecoration(
        label: 'Monthly Income',
        icon: Icons.currency_rupee,
        errorText: errors?['monthlyIncome'],
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final sanitized = Validators.sanitizeNumeric(value);
        if (sanitized != value) {
          _incomeController.value = TextEditingValue(
            text: sanitized,
            selection: TextSelection.collapsed(offset: sanitized.length),
          );
        }
        _onFieldChanged();
      },
    );
  }

  Widget _buildLoanAmountField(Map<String, String>? errors) {
    return TextFormField(
      controller: _loanAmountController,
      decoration: _buildInputDecoration(
        label: 'Requested Loan Amount',
        icon: Icons.account_balance,
        errorText: errors?['requestedLoanAmount'],
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final sanitized = Validators.sanitizeNumeric(value);
        if (sanitized != value) {
          _loanAmountController.value = TextEditingValue(
            text: sanitized,
            selection: TextSelection.collapsed(offset: sanitized.length),
          );
        }
        _onFieldChanged();
      },
    );
  }

  Widget _buildEmploymentDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _employmentType,
      decoration: _buildInputDecoration(
        label: 'Employment Type',
        icon: Icons.work_outline,
      ),
      borderRadius: BorderRadius.circular(12),
      items: AppConstants.employmentTypes
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
          .toList(),
      onChanged: (value) {
        _refreshSession();
        setState(() {
          _employmentType = value ?? AppConstants.employmentTypes.first;
        });
      },
    );
  }

  Widget _buildCreditHistoryToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.blue.shade400, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Credit History',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  _creditHistory == 1
                      ? 'You have existing credit history'
                      : 'No prior credit history',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _creditHistory == 1
                  ? Colors.green.shade50
                  : Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Text(
                    'No',
                    style: TextStyle(
                      fontSize: 12,
                      color: _creditHistory == 0
                          ? Colors.red.shade700
                          : Colors.grey.shade500,
                      fontWeight: _creditHistory == 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  Switch(
                    value: _creditHistory == 1,
                    activeTrackColor: Colors.green.shade200,
                    activeThumbColor: Colors.green.shade600,
                    onChanged: (value) {
                      _refreshSession();
                      setState(() {
                        _creditHistory = value ? 1 : 0;
                      });
                    },
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 12,
                      color: _creditHistory == 1
                          ? Colors.green.shade700
                          : Colors.grey.shade500,
                      fontWeight: _creditHistory == 1
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Selfie',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          'Your data is encrypted and stored securely',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
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
