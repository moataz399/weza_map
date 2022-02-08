// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/business_logic/cubit/places/places_cubit.dart';
import 'package:map/constant/Strings.dart';
import 'package:map/data/repository/maps_repo.dart';
import 'package:map/data/web_services/places_web_services.dart';
import 'package:map/presentation/screens/login_screen.dart';
import 'package:map/presentation/screens/map_screen.dart';
import 'package:map/presentation/screens/otp_screen.dart';

import 'business_logic/cubit/phone_auth/phone_auth_cubit.dart';

class AppRouter {
  PhoneAuthCubit phoneAuthCubit;

  AppRouter() {
    String initialRoute;
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                value: phoneAuthCubit, child: LoginScreen()));
      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                value: phoneAuthCubit,
                child: OtpScreen(
                  phoneNumber: phoneNumber,
                )));
      case mapScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      PlacesCubit(MapsRepository(PlacesWebServices())),
                  child: MapScreen(),
                ));
    }
  }
}
