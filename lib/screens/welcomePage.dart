import 'package:flutter/material.dart';
import 'package:to_do_gdsc/screens/homePage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 300,
          ),
          Center(
            child: Image.asset('assets/logo.png'),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'DooIt',
            style: TextStyle(color: Colors.white, fontSize: 39),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: 200,
            child: const Text(
              'Write What You Need To Do. EveryDay',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          SizedBox(
            height: 55,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
