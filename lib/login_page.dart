
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'forgotPassword_page.dart';
import 'global.dart';
import 'signUp_Page.dart';
import 'package:local_auth/local_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;

  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = false;
    try {
      canCheck = await auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TradingDashboardPage()),
      );
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      print(e);
    }

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TradingDashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loadDesign()
    );
  }

  _loadDesign() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: commonBackgroundGradientColor(),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconAndName(),
              const SizedBox(height: 30),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _emailField(),

                    const SizedBox(height: 20),

                    _passWordField(),

                    const SizedBox(height: 25),

                    // Login Button
                    _buildLoginButton(),
                    const SizedBox(height: 15),

                    _fingerprintAuth(),

                    const SizedBox(height: 15),

                    // Forgot Password
                    _buildForgotPass(),
                    const SizedBox(height: 10),

                    // Sign Up
                    _buildSignup(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   _buildIconAndName() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.bar_chart, color: Colors.amber, size: 80),
        SizedBox(height: 20),
        Text(
          "TradeX Lite",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _emailField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email, color: Colors.white70),
        labelText: "Email",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter your email';
        if (!value.contains('@')) return 'Enter a valid email';
        return null;
      },
    );
  }

  _passWordField() {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter your password';
        return null;
      },
    );
  }

  _buildLoginButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _fingerprintAuth() {
    return _canCheckBiometrics
        ? SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isAuthenticating ? null : _authenticateWithBiometrics,
        icon: const Icon(Icons.fingerprint, color: Colors.white),
        label: const Text(
          "Login with Fingerprint",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white30,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  _buildForgotPass() {
    return  TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPasswordPage(),
          ),
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  _buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TradingSignUpPage(),
              ),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
