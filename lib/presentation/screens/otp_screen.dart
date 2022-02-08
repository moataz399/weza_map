// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:map/business_logic/cubit/phone_auth/phone_auth_state.dart';
import 'package:map/constant/Strings.dart';
import 'package:map/constant/my_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  final phoneNumber  ;
  String otpCode;

  OtpScreen({@required this.phoneNumber});

  void showProgressIndicator(context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify your phone number ',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            child: RichText(
                text: TextSpan(
                    text: 'enter your digit code numbers sent to ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    children: <TextSpan>[
                  TextSpan(
                      text: '$phoneNumber',
                      style: TextStyle(color: MyColors.blue))
                ])))
      ],
    );
  }
  _buildPhoneVerificationBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (BuildContext context, state) {
        if (state is Loading) {
          return showProgressIndicator(context);
        }
        if (state is PhoneOtpSubmited) {
          Navigator.pop(context);
          Navigator.pushNamed(context, mapScreen);
        }
        if (state is Error) {
          //Navigator.pop(context);
          String errormsg = state.error;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errormsg),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: Container(),
    );
  }

  Widget _buildPinCodeFields(context) {
    return Container(
      child: PinCodeTextField(
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeFillColor: MyColors.lightBlue,
          inactiveFillColor: Colors.white,
          inactiveColor: MyColors.blue,

          activeColor: MyColors.blue,
          selectedColor: MyColors.blue,
          selectedFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (code) {
          otpCode=code;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
void _logIn (BuildContext context){
     BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode);
}
  Widget buildVerifyButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        child: Text(
          'verify',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(110, 50),
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        onPressed: () {
          showProgressIndicator(context);
          _logIn(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
          child: Column(
            children: [
              _buildIntroTexts(),
              SizedBox(
                height: 88,
              ),
              _buildPinCodeFields(context),  SizedBox(
                height: 80,
              ),
              buildVerifyButton(context),
              _buildPhoneVerificationBloc()
            ],
          ),
        ),
      ),
    ));
  }
}
