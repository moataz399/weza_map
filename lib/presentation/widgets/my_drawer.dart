// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:map/constant/Strings.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerHeader(BuildContext context) {
      return Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue[100],
            ),
            child: Image.asset('assets/images/moataz.jpg'),
          ),
          Text(
            'moataz mohamed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: Text(
              '${phoneAuthCubit.getLoginUser().phoneNumber}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

    Widget _buildDrawerListItem(
        {@required IconData leadingIcon,
        @required String title,
        Widget trailing,
        Function() onTap,
        Color color}) {
      return ListTile(
        leading: Icon(
          leadingIcon,
          color: color ?? Colors.blue,
        ),
        title: Text(title),
        trailing: trailing ??
            Icon(
              Icons.arrow_right,
              color: Colors.blue,
            ),
        onTap: onTap,
      );
    }

    Widget _buildDivider() {
      return Divider(
        height: 0,
        thickness: 1,
        indent: 18,
        endIndent: 24,
      );
    }

    void _launchUrl(String url) async {
      await canLaunch(url) ? await launch(url) : throw 'can not launch $url';
    }

    Widget buildIcon(IconData icon, String url) {
      return InkWell(
        onTap: () => _launchUrl(url),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      );
    }

    Widget _buildSocialMediaIcon() {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 16),
        child: Row(
          children: [
            buildIcon(FontAwesomeIcons.facebook,
                'https://www.facebook.com/motazz.muhamed.1'),
            const SizedBox(
              width: 15,
            ),
            buildIcon(FontAwesomeIcons.twitter,
                'https://twitter.com/MoatazM17537236'),
            const SizedBox(
              width: 20,
            ),
            buildIcon(FontAwesomeIcons.instagram,
                'https://www.instagram.com/moataz_399/'),
          ],
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 320,
            child: DrawerHeader(
              child: _buildDrawerHeader(context),
              decoration: BoxDecoration(
                color: Colors.blue[100],
              ),
            ),
          ),
          _buildDrawerListItem(
            leadingIcon: Icons.person,
            title: 'my profile',
          ),
          _buildDivider(),
          _buildDrawerListItem(
              leadingIcon: Icons.history,
              title: ' Places History',
              onTap: () {}),
          _buildDivider(),
          _buildDrawerListItem(
            leadingIcon: Icons.settings,
            title: 'Settings',
          ),
          _buildDivider(),
          BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: _buildDrawerListItem(
                trailing: SizedBox(),
                color: Colors.red,
                leadingIcon: Icons.logout,
                title: 'LogOut',
                onTap: () async {
                  await phoneAuthCubit.logOut();
                  Navigator.of(context).pushReplacementNamed(loginScreen);
                }),
          ),
          const SizedBox(
            height: 160,
          ),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          _buildSocialMediaIcon(),
        ],
      ),
    );
  }
}
