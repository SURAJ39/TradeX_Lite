// import 'package:flutter/material.dart';
// import 'global.dart';
// import 'login_page.dart';
//
// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});
//
//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }
//
// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//
//   void _resetPassword() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Password reset link sent to your email."),
//           backgroundColor: Colors.green.shade400,
//         ),
//       );
//       Future.delayed(const Duration(seconds: 2), () {
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
//                       const Icon(Icons.lock_reset,
//                           color: Colors.amber, size: 70),
//                       const SizedBox(height: 12),
//                       const Text(
//                         "Forgot Password",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 1.1,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//
//                       const Text(
//                         "Enter your registered email address and we’ll send you a link to reset your password.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white70, fontSize: 15),
//                       ),
//                       const SizedBox(height: 25),
//
//                       // Email Field
//                       TextFormField(
//                         controller: _emailController,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.email_outlined,
//                               color: Colors.white70),
//                           labelText: "Email",
//                           labelStyle:
//                           const TextStyle(color: Colors.white70),
//                           filled: true,
//                           fillColor: Colors.white.withOpacity(0.05),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide:
//                             const BorderSide(color: Colors.white24),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide:
//                             const BorderSide(color: Colors.amber),
//                           ),
//                         ),
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
//                       const SizedBox(height: 25),
//
//                       // Reset Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _resetPassword,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.amber,
//                             padding:
//                             const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: const Text(
//                             "Send Reset Link",
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // Back to Login
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Remembered your password? ",
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
// }


import 'package:flutter/material.dart';
import 'global.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Password reset link sent to your email."),
          backgroundColor: Colors.green.shade400,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration:
        commonBackgroundGradientColor(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_reset, color: Colors.amber, size: 80),
                const SizedBox(height: 10),
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter your registered email and we'll send a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 25),

                // Email Field
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
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
                      ),
                      const SizedBox(height: 25),

                      // Reset Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Back to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Remembered your password? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
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
