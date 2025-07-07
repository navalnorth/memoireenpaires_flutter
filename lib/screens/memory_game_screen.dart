import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/card_model.dart';
import '../widgets/memory_card.dart';
import '../native_ad_widget.dart'; // ✅ Ajout
import '../ad_banniere.dart'; // ✅ Ajout

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<CardModel> cards = [];
  int? firstFlippedIndex;

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdBottom;
  bool _adShown = false; // ✅ Pour afficher native ad une seule fois

  @override
  void initState() {
    super.initState();
    _initializeCards();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_adShown) {
      Future.delayed(Duration.zero, () {
        _showNativeAdPopup();
        _adShown = true;
      });
    }
  }

  void _showNativeAdPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const NativeAdWidget(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAdTop?.dispose();
    _bannerAdBottom?.dispose();
    super.dispose();
  }

  void _initializeCards() {
    final images = List.generate(8, (index) => 'assets/cards/${index + 1}.png');
    final allImages = [...images, ...images];
    allImages.shuffle(Random());

    cards = allImages.map((img) => CardModel(imagePath: img)).toList();
  }

  void _onCardTap(int index) {
    if (cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;
    });

    if (firstFlippedIndex == null) {
      firstFlippedIndex = index;
    } else {
      final secondIndex = index;
      final firstIndex = firstFlippedIndex!;
      if (cards[firstIndex].imagePath == cards[secondIndex].imagePath) {
        setState(() {
          cards[firstIndex].isMatched = true;
          cards[secondIndex].isMatched = true;
        });
        _checkGameFinished();
      } else {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            cards[firstIndex].isFlipped = false;
            cards[secondIndex].isFlipped = false;
          });
        });
      }
      firstFlippedIndex = null;
    }
  }

  void _checkGameFinished() {
    final allMatched = cards.every((card) => card.isMatched);
    if (allMatched) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('🎉 Bravo !', textAlign: TextAlign.center),
            content: const Text(
              'Vous avez trouvé toutes les paires. Voulez-vous retravailler votre mémoire ?',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initializeCards();
                    firstFlippedIndex = null;
                  });
                },
                child: const Center(child: Text('Oui', textAlign: TextAlign.center)),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Trouvez toutes les paires',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_bannerAdTop != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _bannerAdTop!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdTop!),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 450,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cards.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return MemoryCard(
                        imagePath: cards[index].imagePath,
                        isFlipped: cards[index].isFlipped || cards[index].isMatched,
                        onTap: () => _onCardTap(index),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
