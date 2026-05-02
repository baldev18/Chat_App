import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters.")),
      );
      return;
    }

    String? error = await ap.login(email, password);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Back", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              CustomTextField(hintText: "Email", controller: _emailController, icon: Icons.email),
              SizedBox(height: 15),
              CustomTextField(hintText: "Password", controller: _passwordController, icon: Icons.lock, isPassword: true),
              SizedBox(height: 30),
              ap.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      child: Text("Login"),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: Text("Don't have an account? Sign Up"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
