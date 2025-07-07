import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'memory_game_screen.dart';
import '../ad_banniere.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static var myFont = GoogleFonts.pressStart2p( textStyle: const TextStyle(color: Colors.black, letterSpacing: 2) );
  static var myFontWhite = GoogleFonts.pressStart2p( textStyle: const TextStyle(color: Colors.white, letterSpacing: 2) );

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;

  @override
  void initState() {
    super.initState();

    _bannerAdTop = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();

    _bannerAdBottom = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId!,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAdTop?.dispose();
    _bannerAdBottom?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[700],
      body: SafeArea(
        child: Column(
          children: [
            if (_bannerAdTop != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _bannerAdTop!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdTop!),
              ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Text( "MEMOIRE EN PAIRES", style: myFontWhite.copyWith(fontSize: 15),textAlign: TextAlign.center),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AvatarGlow(
                        duration: const Duration(seconds: 2),
                        glowColor: Colors.white,
                        repeat: true,
                        startDelay: const Duration(seconds: 1),
                        glowCount: 1,
                        child: Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: CircleAvatar(
                            backgroundColor: Colors.deepPurple[800],
                            radius: 55,
                            child: Image.asset( "assets/splash.png", fit: BoxFit.cover ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text( "Développé par @navalnorth", style: myFontWhite.copyWith(fontSize: 11) ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          padding: const WidgetStatePropertyAll( EdgeInsets.symmetric( vertical: 15, horizontal: 30) ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute( builder: (_) => const MemoryGameScreen()));
                        },
                        child: Text("JOUER", style: myFont),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_bannerAdBottom != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _bannerAdBottom!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdBottom!),
              ),
          ],
        ),
      ),
    );
  }
}
