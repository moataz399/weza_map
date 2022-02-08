// @dart =2.9
import 'package:flutter/cupertino.dart';

abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class Loading extends PhoneAuthState {}

class Error extends PhoneAuthState {
  final String error;

  Error({@required this.error});
}

class PhoneNumberSubmited extends PhoneAuthState {}

class PhoneOtpSubmited extends PhoneAuthState {}
