import 'package:cryptoapp/models/coin.dart';
import 'package:cryptoapp/models/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TradeButton extends StatelessWidget {
  final TradeDirection tradeDirection;
  final Coin currency;

  const TradeButton(
      {Key? key, required this.tradeDirection, required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: tradeDirection == TradeDirection.buy
          ? const BorderRadius.only(topLeft: Radius.circular(32))
          : const BorderRadius.only(topRight: Radius.circular(32)),
      child: Container(
        width: 170,
        height: 75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: tradeDirection == TradeDirection.buy
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            end: tradeDirection == TradeDirection.buy
                ? Alignment.topLeft
                : Alignment.topRight,
            colors: const [
              Color(0x00FFFFFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        padding: tradeDirection == TradeDirection.buy
            ? const EdgeInsets.fromLTRB(1, 1, 0, 0)
            : const EdgeInsets.fromLTRB(0, 1, 1, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: tradeDirection == TradeDirection.sell
                  ? const Radius.circular(32)
                  : Radius.zero,
              topLeft: tradeDirection == TradeDirection.buy
                  ? const Radius.circular(32)
                  : Radius.zero,
            ),
            gradient: tradeDirection == TradeDirection.buy
                ? const LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color(0xFF2A4B42),
                      Color(0xFF409166),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFF572E35),
                      Color(0xFFC84747),
                    ],
                  ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  tradeDirection == TradeDirection.buy ? 'Buy' : 'Sell',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    String uid = auth.currentUser!.uid.toString();
                    final docs =
                        FirebaseFirestore.instance.collection('Transactions');
                    final json = {
                      'currency_name': currency.name.toString(),
                      'currency_price': currency.price.toString(),
                      'Time': DateTime.now(),
                      'uid': uid
                    };
                    await docs.add(json);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
