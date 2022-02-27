class Goal {
  int id;
  String nama;
  double jumlahTarget;
  double jumlahSekarang;
  DateTime tanggal;
  String keterangan;

  Goal(
      {required this.id,
      required this.nama,
      required this.jumlahTarget,
      required this.jumlahSekarang,
      required this.tanggal,
      required this.keterangan});
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
        id: json['id'],
        nama: json['nama'],
        jumlahTarget:double.parse(json['jumlah'].toString()),
        jumlahSekarang: double.parse(json['jumlah_cicilan'].toString()),
        tanggal: DateTime.parse(json['tanggal']),
        keterangan: json['keterangan']);
  }
}

var listGoals = <Goal>[];
