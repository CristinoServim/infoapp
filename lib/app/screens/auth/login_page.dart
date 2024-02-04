// login_page.dart
import 'package:flutter/material.dart';
import 'package:infoapp/app/auth/authentication_service.dart';
import 'package:infoapp/app/widgets/buttons/custon_elevated_button.dart';
import 'package:validatorless/validatorless.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/LoadInfobrasil.mp4')
          ..initialize().then((context) {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Center(
                    child: Card(
                      elevation: 8,
                      margin: const EdgeInsets.all(26),
                      child: Padding(
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                username = value;
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Usuario'),
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                              ]),
                            ),
                            TextFormField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: 'Senha'),
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                              ]),
                            ),
                            const SizedBox(height: 16),
                            CustomElevatedButton(
                              onPressed: () {
                                //if (_formKey.currentState?.validate() ??
                                //   false) {
                                AuthenticationService.authenticate(
                                  username: username,
                                  password: password,
                                  context: context,
                                );
                                // }
                              },
                              text: 'Entrar',
                              textColor: Theme.of(context).colorScheme.primary,
                              buttonColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/registro');
                              },
                              child: Text(
                                'Registrar',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        ),
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
}
