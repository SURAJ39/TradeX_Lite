// import 'package:flutter/material.dart';
// import 'global.dart';
// import 'login_page.dart';
//
// class TradingSignUpPage extends StatefulWidget {
//   const TradingSignUpPage({super.key});
//
//   @override
//   State<TradingSignUpPage> createState() => _TradingSignUpPageState();
// }
//
// class _TradingSignUpPageState extends State<TradingSignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isPasswordVisible = false;
//
//   void _register() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );
//       Future.delayed(const Duration(seconds: 1), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: commonBackgroundGradientColor(),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
//             child: Card(
//               elevation: 10,
//               color: Colors.white.withOpacity(0.1),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.account_balance_wallet,
//                           color: Colors.amber, size: 70),
//                       const SizedBox(height: 12),
//                       const Text(
//                         "Create Account",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 1.1,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//
//                       // Full Name
//                       TextFormField(
//                         style: const TextStyle(color: Colors.white),
//                         decoration: _inputDecoration(
//                             label: "Full Name", icon: Icons.person_outline),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter your full name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Email
//                       TextFormField(
//                         style: const TextStyle(color: Colors.white),
//                         decoration: _inputDecoration(
//                             label: "Email", icon: Icons.email_outlined),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter your email';
//                           }
//                           if (!value.contains('@')) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Password
//                       TextFormField(
//                         style: const TextStyle(color: Colors.white),
//                         obscureText: !_isPasswordVisible,
//                         decoration: _inputDecoration(
//                           label: "Password",
//                           icon: Icons.lock_outline,
//                           suffix: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: Colors.white70,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 25),
//
//                       // Register Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _register,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.amber,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: const Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 18),
//
//                       // Already have account
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Already have an account? ",
//                             style: TextStyle(color: Colors.white70),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                     const LoginPage()),
//                               );
//                             },
//                             child: const Text(
//                               "Login",
//                               style: TextStyle(
//                                 color: Colors.amber,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(
//       {required String label, required IconData icon, Widget? suffix}) {
//     return InputDecoration(
//       prefixIcon: Icon(icon, color: Colors.white70),
//       suffixIcon: suffix,
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.white70),
//       filled: true,
//       fillColor: Colors.white.withOpacity(0.05),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.white24),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.amber),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'global.dart';
import 'login_page.dart';

class TradingSignUpPage extends StatefulWidget {
  const TradingSignUpPage({super.key});

  @override
  State<TradingSignUpPage> createState() => _TradingSignUpPageState();
}

class _TradingSignUpPageState extends State<TradingSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  InputDecoration _inputDecoration({required String label, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffix,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: commonBackgroundGradientColor(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 80),
                const SizedBox(height: 10),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sign up to start trading with your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(label: "Full Name", icon: Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter your full name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(label: "Email", icon: Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter your email';
                          if (!value.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: !_isPasswordVisible,
                        decoration: _inputDecoration(
                          label: "Password",
                          icon: Icons.lock_outline,
                          suffix: IconButton(
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
                          if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Back to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
