import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

import '../authentication/phoneNumber.dart';
import '../providers/profile.dart';
import '../widgets/showProfileTIle.dart';

class ProfileScreen extends StatelessWidget {
  static const route = '/profileScreen';

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    List<Profile> _profiles = Provider.of<ProfileProvider>(context).profile;

    return Scaffold(
      backgroundColor: const Color(0xffEAEBF3),
      appBar: NeuAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xff8b3365),
        ),
        title: const Text(
          'Profile',
          style: const TextStyle(
            fontFamily: 'RalewayMed',
            fontWeight: FontWeight.w500,
            color: const Color(0xff8b3365),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   Provider.of<ProfileProvider>(context, listen: false).deleteProfiles();
      // }),
      body: Container(
        height: _height,
        width: _width,
        alignment: Alignment.center,
        child: ListView.builder(
            itemCount: _profiles.length + 1,
            itemBuilder: (ctx, i) {
              if (i == _profiles.length) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.677,
                  margin:  const EdgeInsets.only(top: 30, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Add new member',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff8b3365),
                        ),
                      ),
                  const SizedBox(width: 15),
                      NeuButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(PhoneNumberScreen.route);
                        },
                        child: const Icon(
                          Icons.add,
                          color: const Color(0xff8b3365),
                        ),
                        decoration: NeumorphicDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container(
                alignment: Alignment.center,
                child: ProfileTile(_profiles[i]),
              );
            }),
      ),
    );
  }
}
