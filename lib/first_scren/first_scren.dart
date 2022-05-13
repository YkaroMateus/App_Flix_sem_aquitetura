import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home_page/home_page.dart';

class FirstRoute extends StatefulWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  TextEditingController userController = TextEditingController();

  String password = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: (() {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Codeflix version 1.0.0')));
                    }),
                    icon: Icon(
                      Icons.info_sharp,
                      size: 25,
                    ),
                    tooltip: 'Informações',
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(30)),
            SizedBox(
              child: Image.asset(
                'assets/first_scren-removebg.png',
                height: 300,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 190,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: userController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'User',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    TextField(
                      onChanged: (text) {
                        password = text;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 20),
                    primary: Colors.blue,
                    elevation: 15,
                    shadowColor: Color.fromARGB(255, 0, 4, 189)),
                onPressed: () {
                  if (userController.text == 'user' && password == '12345') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const HomePage())));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'ERROR :(\n\n Unable to login,\nUsername or credentials are incorrect !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        alignment: Alignment.center,
                        backgroundColor: Colors.red,
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                              style: ButtonStyle(alignment: Alignment.center),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'OK',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
