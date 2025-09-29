import 'package:flutter/material.dart';

class steamBuilders extends StatelessWidget {
  // jo k ama yaha bana raha Stream ka function
  Stream fetchData() async* {
    // agr ek value return krni ha to return lagya ga or
    // stream ma asyn ka sath * lagta ha or return ko jaga yeild use krta ha jis sa
    // sara data ata ha
    //  return 12;
    yield 12;
  }

  const steamBuilders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            // stream ka data lana kaliya Stream ka function bana parta ha
            stream: fetchData(),
            // builder jo hota ha wo ui ko build krta ha
            // builder ma context or dnapshot pass krta ha
            builder: (context, onlinedata) {
              if (onlinedata.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {}

              return Text(onlinedata.data.toString());
            },
          ),
        ],
      ),
    );
  }
}
