import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assigment_tezcredit/core/di/injection_container.dart';
import 'package:assigment_tezcredit/core/security/session_manager.dart';
import 'package:assigment_tezcredit/core/utils/currency_formatter.dart';
import 'package:assigment_tezcredit/presentation/bloc/emi_bloc.dart';
import 'package:assigment_tezcredit/presentation/mixins/screenshot_prevention_mixin.dart';
import 'package:assigment_tezcredit/presentation/widgets/blur_overlay.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen>
    with ScreenshotPreventionMixin {
  late final EmiBloc _emiBloc;

  double _loanAmount = 500000;
  double _interestRate = 10.0;
  double _tenureYears = 3;

  static const double _minLoanAmount = 50000;
  static const double _maxLoanAmount = 5000000;
  static const double _minInterestRate = 1;
  static const double _maxInterestRate = 30;
  static const double _minTenureYears = 1;
  static const double _maxTenureYears = 30;

  @override
  void initState() {
    super.initState();
    _emiBloc = sl<EmiBloc>();
    _calculateEmi();
    initScreenshotPrevention();
  }

  @override
  void dispose() {
    disposeScreenshotPrevention();
    _emiBloc.close();
    super.dispose();
  }

  void _calculateEmi() {
    sl<SessionManager>().refreshSession();
    _emiBloc.add(EmiInputChanged(
      amount: _loanAmount,
      rate: _interestRate,
      tenure: (_tenureYears * 12).round(),
    ));
  }

  String _formatCurrency(double value) => CurrencyFormatter.formatShort(value);

  String _formatFullCurrency(double value) =>
      CurrencyFormatter.formatIndian(value);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _emiBloc,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('EMI Calculator'),
              centerTitle: true,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLoanAmountSlider(),
                    const SizedBox(height: 16),
                    _buildInterestRateSlider(),
                    const SizedBox(height: 16),
                    _buildTenureSlider(),
                    const SizedBox(height: 24),
                    _buildResultCard(),
                  ],
                ),
              ),
            ),
          ),
          if (showBlurOverlay) const BlurOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoanAmountSlider() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.currency_rupee,
                        size: 20, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Loan Amount',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatFullCurrency(_loanAmount),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _loanAmount,
              min: _minLoanAmount,
              max: _maxLoanAmount,
              divisions: 99,
              activeColor: Colors.blue.shade700,
              onChanged: (value) {
                setState(() {
                  _loanAmount = (value / 10000).round() * 10000;
                });
                _calculateEmi();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\u20B9${_formatCurrency(_minLoanAmount)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '\u20B9${_formatCurrency(_maxLoanAmount)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestRateSlider() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.percent,
                        size: 20, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Interest Rate',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_interestRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _interestRate,
              min: _minInterestRate,
              max: _maxInterestRate,
              divisions: 58,
              activeColor: Colors.orange.shade700,
              onChanged: (value) {
                setState(() {
                  _interestRate =
                      (value * 2).round() / 2; // snap to 0.5 increments
                });
                _calculateEmi();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_minInterestRate.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${_maxInterestRate.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenureSlider() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month,
                        size: 20, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Loan Tenure',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_tenureYears.round()} ${_tenureYears.round() == 1 ? 'Year' : 'Years'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _tenureYears,
              min: _minTenureYears,
              max: _maxTenureYears,
              divisions: 29,
              activeColor: Colors.green.shade700,
              onChanged: (value) {
                setState(() {
                  _tenureYears = value.roundToDouble();
                });
                _calculateEmi();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_minTenureYears.round()} Year',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${_maxTenureYears.round()} Years',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return BlocBuilder<EmiBloc, EmiState>(
      builder: (context, state) {
        if (state is EmiCalculated) {
          return Card(
            elevation: 3,
            color: Colors.blue.shade50,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Monthly EMI',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFullCurrency(state.emi),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          'Total Payment',
                          _formatFullCurrency(state.totalPayment),
                          Icons.account_balance_wallet,
                          Colors.green.shade700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          'Total Interest',
                          _formatFullCurrency(state.totalInterest),
                          Icons.trending_up,
                          Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'Adjust sliders to calculate EMI',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
