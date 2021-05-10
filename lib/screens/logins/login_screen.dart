import 'package:flutter/material.dart';
import 'package:kst_survey/screens/summary_screen.dart';
import 'package:kst_survey/services/firestore_service.dart';
import 'package:kst_survey/widgets/alert_progress.dart';

class LoginScreen extends StatefulWidget {
  static String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

FireStoreService _fireStoreService = FireStoreService();

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: 500,
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('assets/images/security_lock.png'),
                            width: 100,
                          ),
                          Text(
                            'Authentication',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _inputText(
                            controller: emailController,
                            secure: false,
                            hint: 'Email',
                            icon: Icons.email,
                            validator: (String value) =>
                                value.isEmpty ? "ອີເມລບໍ່ສາມາດວ່າງໄດ້" : null,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _inputText(
                            controller: passwordController,
                            secure: true,
                            hint: 'Password',
                            icon: Icons.lock,
                            validator: (String value) => value.length < 6
                                ? "ລະຫັດຕ້ອງຫຼາຍກວ່າ 6 ຕົວອັກສອນ"
                                : null,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          _logInButton(),
                          SizedBox(
                            height: 25,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text('Forget Password?')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _inputText(
      {String hint,
      TextEditingController controller,
      bool secure,
      IconData icon,
      FormFieldValidator<String> validator}) {
    return TextFormField(
      obscureText: secure,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        hintText: hint,
        border: OutlineInputBorder(borderSide: BorderSide.none),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  _logInButton() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState.validate()) {
          AlertProgress(context: context).loadingAlertDialog();
          _fireStoreService
              .loginWithEmail(
                  email: emailController.text,
                  password: passwordController.text)
              .then((value) {
            Navigator.pop(context);
            Navigator.of(context).pushNamedAndRemoveUntil(SummaryScreen.route, (route) => false);
          }).catchError((err) {
            Navigator.pop(context);
            AlertProgress(context: context, message: err).errorDialog();
          });
        }
      },
      child: Container(
        width: 500,
        height: 50,
        child: Center(
          child: Text('Login'),
        ),
      ),
    );
  }
}
