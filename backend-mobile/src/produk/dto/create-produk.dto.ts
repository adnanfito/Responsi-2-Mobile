export class CreateProdukDto {
  nama: string;
  harga: string | number; // ✅ Accept both string dan number
  jumlah: string | number;
  tanggal_masuk: string;
}
