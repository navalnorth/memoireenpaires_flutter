import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../widgets/memory_card.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<CardModel> cards = [];
  int? firstFlippedIndex;

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final images = List.generate(8, (index) => 'assets/cards/${index + 1}.png');
    final allImages = [...images, ...images]; // paires
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
      if (cards[firstFlippedIndex!].imagePath == cards[secondIndex].imagePath) {
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
            title: const Text('🎉 Bravo !', textAlign: TextAlign.center,),
            content: const Text('Vous avez trouvé toutes les paires. Voulez-vous retravailler votre mémoire ?', textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initializeCards();
                    firstFlippedIndex = null;
                  });
                },
                child: Center(child: const Text('Oui', textAlign: TextAlign.center,)),
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
        title: const Text( 'Trouvez toutes les paires', style: TextStyle(fontWeight: FontWeight.bold) ),
        centerTitle: true,
      ),
      body: SafeArea(
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
    );
  }
}
