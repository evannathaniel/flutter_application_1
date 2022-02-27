class Loan{
  int id;
  String nama;
  double jumlah;
  double jumlahCicilan;
  DateTime tanggal;
  String keterangan;
  int jatuhTempo;
  double jumlahPerbulan;

  Loan({required this.id,required this.nama,required this.jumlah,required this.jumlahCicilan,required this.tanggal,required this.keterangan,
  required this.jatuhTempo,required this.jumlahPerbulan});
  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
        id: json['id'],
        nama: json['nama'],
        jumlah: double.parse(json['jumlah'].toString()),
        jumlahCicilan: double.parse(json['jumlah_cicilan'].toString()),
        tanggal: DateTime.parse(json['tanggal']),
        keterangan: json['keterangan'],
        jatuhTempo: json['tanggal_jatuh_tempo'],
        jumlahPerbulan: double.parse(json['jumlahPerbulan'].toString()));
  }
}
var listLoans = <Loan>[];