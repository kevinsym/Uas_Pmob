class Dosen{
  String id;
  String nidn_dosen;
  String nama_dosen;

  Dosen({this.id, this.nidn_dosen, this.nama_dosen});

  factory Dosen.fromJson(Map<String, dynamic> json){
    return Dosen(
      id: json['id'] as String,
      nidn_dosen: json['nidn_dosen'] as String,
      nama_dosen: json['nama_dosen'] as String,
    );
  }


}