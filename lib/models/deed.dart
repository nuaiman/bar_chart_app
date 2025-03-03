class Deed {
  final int id;
  final String titleEn;
  final String titleBn;
  bool type;
  String dayOfWeek;
  int day;
  int month;
  int year;

  Deed({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.type,
    required this.dayOfWeek,
    required this.day,
    required this.month,
    required this.year,
  });

  @override
  String toString() {
    return 'Deed(id: $id, titleEn: $titleEn, titleBn: $titleBn, type: $type, dayOfWeek: $dayOfWeek, day: $day, month: $month, year: $year)';
  }

  Deed copyWith({
    int? id,
    String? titleEn,
    String? titleBn,
    bool? type,
    String? dayOfWeek,
    int? day,
    int? month,
    int? year,
  }) {
    return Deed(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleBn: titleBn ?? this.titleBn,
      type: type ?? this.type,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  @override
  bool operator ==(covariant Deed other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.titleEn == titleEn &&
        other.titleBn == titleBn &&
        other.type == type &&
        other.dayOfWeek == dayOfWeek &&
        other.day == day &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        titleEn.hashCode ^
        titleBn.hashCode ^
        type.hashCode ^
        dayOfWeek.hashCode ^
        day.hashCode ^
        month.hashCode ^
        year.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleBn': titleBn,
      'type': type,
      'dayOfWeek': dayOfWeek,
      'day': day,
      'month': month,
      'year': year,
    };
  }

  factory Deed.fromJson(Map<String, dynamic> json) {
    return Deed(
      id: json['id'],
      titleEn: json['titleEn'],
      titleBn: json['titleBn'],
      type: json['type'],
      dayOfWeek: json['dayOfWeek'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
    );
  }
}
