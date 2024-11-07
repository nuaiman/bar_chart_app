import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/deed.dart';

class DefaultDeedsController extends StateNotifier<List<Deed>> {
  DefaultDeedsController()
      : super([
          Deed(
            id: 1,
            titleEn: 'Faith in Allah (Surah Al-Baqarah: 2:258)',
            titleBn: 'আল্লাহর প্রতি ঈমান (সূরা বাকারা : ২৫৮)',
            type: true,
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
          Deed(
            id: 2,
            titleEn: 'Faith in the Angels (Surah Al-Baqarah: 2:285)',
            titleBn: 'ফেরেশতাদের প্রতি বিশ্বাস (সূরা বাকারা: ২৮৫)',
            type: true,
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
          Deed(
            id: 3,
            titleEn: 'Faith in the Heavenly Books (Surah Al-Baqarah: 2:285)',
            titleBn: 'আসমানী কিতাবসমূহের প্রতি বিশ্বাস (সূরা বাকারা: ২৮৫)',
            type: true,
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
          Deed(
            id: 4,
            titleEn: 'Faith in the Prophets (Surah Al-Baqarah: 2:136)',
            titleBn: 'রাসূলগণের প্রতি ঈমান আনা (সূরা বাকারা: ১৩৬)',
            type: true,
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
          Deed(
            id: 5,
            titleEn: 'Faith in Divine Decree (Surah An-Nisa: 4:78)',
            titleBn: 'তাকদীরের প্রতি ঈমান আনা (সূরা আন-নিসা: ৭৮)',
            type: true,
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
          Deed(
            id: 6,
            titleEn: 'Faith in the Hereafter (Surah At-Tawbah: 9:29)',
            titleBn: 'আখেরাতের প্রতি বিশ্বাস (সূরা আত-তওবা: ২৯)',
            type: true,
            dayOfWeek: DateFormat('EEEE').format(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
        ]);

  Deed getDeedById(int id) {
    return state.firstWhere(
      (deed) => deed.id == id,
    );
  }
}
// -----------------------------------------------------------------------------

final defaultDeedsProvider =
    StateNotifierProvider<DefaultDeedsController, List<Deed>>((ref) {
  return DefaultDeedsController();
});
