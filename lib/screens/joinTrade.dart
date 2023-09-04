
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zelix_trade/screens/home.dart';
import 'package:zelix_trade/screens/tradearea.dart';

class JoinTrade extends StatefulWidget {
  const JoinTrade({super.key});

  @override
  State<JoinTrade> createState() => _JoinTradeState();
}

class _JoinTradeState extends State<JoinTrade> {
  String joinid = '';
  String notjoiningerror = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Scaffold(
            backgroundColor: const Color.fromARGB(255, 90, 71, 15),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(198, 255, 191, 0),
              title: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Text(
                    'Zelix Trade',
                    style: GoogleFonts.pacifico(fontSize: 22, letterSpacing: 4),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                ],
              ),
            ),
            body: Center(
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.softLight,
                        ),
                        image: AssetImage("assets/images/tradebg.png"),
                        //repeat: ImageRepeat.repeat,
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.topCenter,
                        opacity: 0.3)),
                child: Column(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Enter The ID',
                          style: GoogleFonts.pacifico(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 30,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1),
                      ),
                      child: Container(
                        child: TextField(
                          cursorColor: Colors.brown,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (v) => setState(() {
                            joinid = v;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        notjoiningerror,
                        style: GoogleFonts.pacifico(
                            color: Colors.redAccent,
                            fontSize: 20,
                            decoration: TextDecoration.none,
                            letterSpacing: 4),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                          },
                          style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.white38),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(198, 255, 191, 0),),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ))),
                          child: Container(
                              margin: const EdgeInsets.all(15),
                              child: Text(
                                'BACK',
                                style: GoogleFonts.pacifico(
                                    fontSize: 28, color: Colors.black),
                              )),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List<Map<String, dynamic>> joinidmap = await Supabase.instance.client.from('rooms').select<List<Map<String, dynamic>>>('id').eq('id',joinid);
                            if (joinidmap.isNotEmpty) {
                              setState(() {
                                notjoiningerror = '';
                              });
                              String mynickname = await Supabase.instance.client.auth.currentUser!.userMetadata!['nickname'];
                              await Supabase.instance.client.from('rooms').update({'tradesman2': mynickname}).eq('id', joinid).then((value) async => 
                                  await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const TradeArea()), ));
                            } 
                            else {
                              setState(() {
                                notjoiningerror = 'Check the id';
                              });
                            }
                          },
                          style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.white38),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(198, 255, 191, 0),),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ))),
                          child: Container(
                              margin: const EdgeInsets.all(15),
                              child: Text(
                                'START',
                                style: GoogleFonts.pacifico(
                                    fontSize: 28, color: Colors.black),
                              )),
                        ),
                      ],
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
