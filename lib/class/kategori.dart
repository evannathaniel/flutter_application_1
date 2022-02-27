class Kategori {
  int id;
  String nama;

  Kategori({required this.id, required this.nama});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
    );
  }
}

var listKategori = <Kategori>[];
var listKategori1 = <Kategori>[];
var mapK = listKategori.asMap();
var mapK1 = listKategori1.asMap();
