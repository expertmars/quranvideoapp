import 'dart:convert';

class Ayah {
  final String id;
  final String glyph;

  String? local;
  String? eng;
  final int number;
  final int surah;
  final int pageno;
  int? endingTime;
  bool setted;

  Ayah(
      {required this.id,
      required this.glyph,
      this.local,
      this.eng,
      required this.number,
      required this.surah,
      required this.pageno,
      this.endingTime,
      this.setted = false});

  @override
  String toString() {
    return 'Ayah(glyph: $glyph, local: $local, eng: $eng, number: $number, surah: $surah, pageno: $pageno, endingTime: $endingTime)';
  }

  String fontFamily() {
    return "p2" + pageno.toString().padLeft(3, '0');
  }

  Ayah copyWith({
    String? id,
    String? glyph,
    String? local,
    String? eng,
    int? number,
    int? surah,
    int? pageno,
    int? endingTime,
    bool setted = false,
  }) {
    return Ayah(
      id: id ?? this.id,
      glyph: glyph ?? this.glyph,
      local: local ?? this.local,
      eng: eng ?? this.eng,
      number: number ?? this.number,
      surah: surah ?? this.surah,
      pageno: pageno ?? this.pageno,
      endingTime: endingTime,
      setted: setted,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'glyph': glyph});
    if (local != null) {
      result.addAll({'local': local});
    }
    if (eng != null) {
      result.addAll({'eng': eng});
    }
    result.addAll({'number': number});
    result.addAll({'surah': surah});
    result.addAll({'pageno': pageno});
    if (endingTime != null) {
      result.addAll({'endingTime': endingTime});
    }
    result.addAll({'setted': setted});

    return result;
  }

  factory Ayah.fromMap(Map<String, dynamic> map) {
    return Ayah(
      id: map['id'] ?? '',
      glyph: map['glyph'] ?? '',
      local: map['local'],
      eng: map['eng'],
      number: map['number']?.toInt() ?? 0,
      surah: map['surah']?.toInt() ?? 0,
      pageno: map['pageno']?.toInt() ?? 0,
      endingTime: map['endingTime']?.toInt(),
      setted: map['setted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ayah.fromJson(String source) => Ayah.fromMap(json.decode(source));
}

enum EditingType { ayah, eng, local }
