import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';

  late Timer _timer;
  int _start = 60;

  void resend() {
    setState(() {
      _isResendAgain = false;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });
    const oneSec = Duration(milliseconds: 10000);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: Transform.rotate(
                  angle: 38,
                  child: const Image(
                    image: AssetImage("assets/email-1.png"),
                  ),
                ),
              ),
              const SizedBox(
                height: 82,
              ),
              const Text(
                "Verification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please enter the 6 digit code sent to \n +93 786-399-999",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.grey.shade500, height: 1.5),
              ),
              const SizedBox(
                height: 30,
              ),
              VerificationCode(
                  length: 6,
                  textStyle: const TextStyle(fontSize: 20),
                  underlineColor: Colors.blueAccent,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    setState(() {
                      _code = value;
                    });
                  },
                  onEditing: (value) {}),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't received the OTP?",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  TextButton(
                      onPressed: () {
                        if (_isLoading) return;
                        resend();
                      },
                      child: Text(
                        _isResendAgain
                            ? "Try again in" + _start.toString()
                            : "Resend",
                        style: const TextStyle(color: Colors.blueAccent),
                      )),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              MaterialButton(
                disabledColor: Colors.grey.shade300,
                onPressed: _code.length < 6
                    ? null
                    : () {
                        verify();
                      },
                color: Colors.black,
                minWidth: double.infinity,
                height: 50,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                          color: Colors.black,
                        ),
                      )
                    : _isVerified
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 30,
                          )
                        : const Text(
                            "Verify",
                            style: TextStyle(color: Colors.white),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
