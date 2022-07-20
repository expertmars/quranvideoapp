class Ayah {
  final String glyph;
  String? local;
  String? eng;
  final int number;
  final int surah;
  final int pageno;

  Ayah({
    required this.glyph,
    this.local,
    this.eng,
    required this.number,
    required this.surah,
    required this.pageno,
  });

  @override
  String toString() {
    return 'Ayah(glyph: $glyph, local: $local, eng: $eng, number: $number, surah: $surah, pageno: $pageno)';
  }
}
