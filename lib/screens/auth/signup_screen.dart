import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String? error = await ap.signUp(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim()
    );
    
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
              Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              CustomTextField(hintText: "Name", controller: _nameController, icon: Icons.person),
              SizedBox(height: 15),
              CustomTextField(hintText: "Email", controller: _emailController, icon: Icons.email),
              SizedBox(height: 15),
              CustomTextField(hintText: "Password", controller: _passwordController, icon: Icons.lock, isPassword: true),
              SizedBox(height: 30),
              ap.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      child: Text("Sign Up"),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
