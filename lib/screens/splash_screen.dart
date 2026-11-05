import 'package:financeapps/utils/app_color.dart';
import 'package:financeapps/utils/formatter.dart';
import 'package:financeapps/models/transaction_model.dart';
import 'package:financeapps/services/transaction_service.dart';
import 'package:financeapps/widgets/brandmark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _next();
  }

  Future<void> _next() async {
    // Tampilkan logo minimal 2 detik sambil menunggu sesi login dipulihkan.
    final results = await Future.wait([
      AuthService().sessionUser(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]);
    if (!mounted) return;
    final loggedIn = results.first != null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 88,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'Catatan Keuangan',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Catat uang masuk dan keluar dengan mudah.',
              style: TextStyle(color: AppColor.onPrimaryMuted),
            ),
          ],
        ),
      ),
    );
  }
}
