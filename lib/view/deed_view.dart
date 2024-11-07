import 'package:bar_chart_app/controllers/default_deeds_controllers.dart';
import 'package:bar_chart_app/controllers/negative_deeds_controller.dart';
import 'package:bar_chart_app/controllers/positive_deeds_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/deeds_controllers.dart';
import '../models/deed.dart';

class DeedsView extends ConsumerStatefulWidget {
  const DeedsView({super.key});

  @override
  ConsumerState<DeedsView> createState() => _DeedsViewState();
}

class _DeedsViewState extends ConsumerState<DeedsView> {
  int _currentIndex = 0;

  void _changeIndex(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Deed> defaultDeeds = ref.read(defaultDeedsProvider);
    List<Deed> positiveDeeds = ref.read(positiveDeedsProvider);
    List<Deed> negativeDeeds = ref.read(negativeDeedsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deeds'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  _changeIndex(0);
                },
                child: const Text('Positive'),
              ),
              TextButton(
                onPressed: () {
                  _changeIndex(1);
                },
                child: const Text('Negative'),
              ),
              TextButton(
                onPressed: () {
                  _changeIndex(2);
                },
                child: const Text('Default'),
              ),
            ],
          ),
          // -------------------------------------------------------------------
          _currentIndex == 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: positiveDeeds.length,
                    itemBuilder: (context, index) {
                      Deed deed = positiveDeeds[index];
                      bool hasThisDeed =
                          ref.watch(deedsProvider.notifier).hasThisDeed(deed);
                      int thisDeedCount = ref
                          .watch(deedsProvider.notifier)
                          .getDeedWithSameIdAndTypeCount(deed.id, true);
                      return Card(
                        color: hasThisDeed ? Colors.green : null,
                        surfaceTintColor: hasThisDeed ? Colors.green : null,
                        child: ListTile(
                          title: Text(deed.titleEn),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              thisDeedCount > 0
                                  ? Container(
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Text(
                                            thisDeedCount.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  thisDeedCount > 0
                                      ? GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(deedsProvider.notifier)
                                                .removeDeed(deed, context);
                                          },
                                          child: const CircleAvatar(
                                            radius: 17,
                                            backgroundColor: Colors.black,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  Color(0xFFDD636E),
                                              child: Icon(Icons.close),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(deedsProvider.notifier)
                                          .addDeed(deed, context);
                                    },
                                    child: const CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Color(0xFF80cb8e),
                                        child: Icon(Icons.done),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : _currentIndex == 1
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: negativeDeeds.length,
                        itemBuilder: (context, index) {
                          Deed deed = negativeDeeds[index];
                          bool hasThisDeed = ref
                              .watch(deedsProvider.notifier)
                              .hasThisDeed(deed);
                          int thisDeedCount = ref
                              .watch(deedsProvider.notifier)
                              .getDeedWithSameIdAndTypeCount(deed.id, false);
                          return Card(
                            color: hasThisDeed ? Colors.red : null,
                            surfaceTintColor: hasThisDeed ? Colors.red : null,
                            child: ListTile(
                              title: Text(deed.titleEn),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  thisDeedCount > 0
                                      ? Container(
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Text(
                                                thisDeedCount.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      thisDeedCount > 0
                                          ? GestureDetector(
                                              onTap: () {
                                                ref
                                                    .read(
                                                        deedsProvider.notifier)
                                                    .removeDeed(deed, context);
                                              },
                                              child: const CircleAvatar(
                                                radius: 17,
                                                backgroundColor: Colors.black,
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Color(0xFFDD636E),
                                                  child: Icon(Icons.close),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(deedsProvider.notifier)
                                              .addDeed(deed, context);
                                        },
                                        child: const CircleAvatar(
                                          radius: 17,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Color(0xFF80cb8e),
                                            child: Icon(Icons.done),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: positiveDeeds.length,
                        itemBuilder: (context, index) {
                          Deed deed = positiveDeeds[index];
                          return Card(
                            color: Colors.green,
                            surfaceTintColor: Colors.green,
                            child: ListTile(
                              title: Text(deed.titleEn),
                            ),
                          );
                        },
                      ),
                    )
        ],
      ),
    );
  }
}
