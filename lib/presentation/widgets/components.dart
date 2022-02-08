import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/business_logic/cubit/phone_auth/phone_auth_cubit.dart';

// Widget signOut ()=> Center(
//   child: Container(
//     child: BlocProvider<PhoneAuthCubit>(
//       create: (context) => phoneAuthCubit,
//       child: ElevatedButton(
//         child: Text(
//           'Log out',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         style: ElevatedButton.styleFrom(
//             minimumSize: Size(110, 50),
//             primary: Colors.black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//             )),
//         onPressed: () async {
//           await phoneAuthCubit.logOut();
//           Navigator.of(context).pushReplacementNamed(loginScreen);
//         },
//       ),
//     ),
//   ),
// );



//AppBar(
// backgroundColor: Colors.transparent,
// elevation: 1.0,
// title: Text('google Maps'),
// actions: [
//   IconButton(onPressed: () {}, icon: Icon(Icons.search)),
//   if (_origin != null)
//     TextButton(
//         onPressed: () =>
//             mapController.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(
//                   target: _origin.position, zoom: 17, tilt: 50),
//             )),
//         child: Text('origin ')),
//   if (_destination != null)
//     TextButton(
//         onPressed: () {
//           mapController.animateCamera(CameraUpdate.newCameraPosition(
//             CameraPosition(
//                 target: _destination.position, zoom: 17, tilt: 50),
//           ));
//         },
//         child: Text('DEST '))
// ],
//),