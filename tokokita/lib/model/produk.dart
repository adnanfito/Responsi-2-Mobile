class Produk {
  int? id;
  String? namaProduk;
  int? hargaProduk;
  int? jumlah;
  String? tanggalMasuk;

  Produk({
    this.id,
    this.jumlah,
    this.namaProduk,
    this.hargaProduk,
    this.tanggalMasuk,
  });

  factory Produk.fromJson(Map<String, dynamic> obj) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    final dynamic namaField = obj['nama'] ?? obj['nama_produk'];
    final dynamic hargaField = obj['harga'] ?? obj['harga_produk'];
    final dynamic jumlahField = obj['jumlah'] ?? obj['qty'] ?? obj['stock'];
    final dynamic tanggalField = obj['tanggal_masuk'] ?? obj['tanggalMasuk'];

    return Produk(
      id: obj['id'] is int
          ? obj['id'] as int
          : (obj['id'] is String ? int.tryParse(obj['id']) : null),
      jumlah: parseInt(jumlahField),
      namaProduk: namaField?.toString(),
      hargaProduk: parseInt(hargaField),
      tanggalMasuk: tanggalField?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      // kirim dua key nama untuk safety (ubah sesuai backend)
      'nama': namaProduk ?? '',
      'nama_produk': namaProduk ?? '',
      // kirim numbers (int) jika backend expects int (prisma)
      'harga': hargaProduk ?? 0,
      'jumlah': jumlah ?? 0,
      'tanggal_masuk': tanggalMasuk ?? '',
    };
  }

  @override
  String toString() {
    return 'Produk{id: $id, nama: $namaProduk, harga: $hargaProduk, jumlah: $jumlah, tanggal_masuk: $tanggalMasuk}';
  }
}
