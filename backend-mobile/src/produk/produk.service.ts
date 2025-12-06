import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProdukDto } from './dto/create-produk.dto';
import { UpdateProdukDto } from './dto/update-produk.dto';

@Injectable()
export class ProdukService {
  constructor(private prisma: PrismaService) {}

  async create(createProdukDto: CreateProdukDto) {
    try {
      console.log('🔵 [Produk Service] Creating produk:', createProdukDto);

      // ✅ Parse harga dari string ke int
      const harga =
        typeof createProdukDto.harga === 'string'
          ? parseInt(createProdukDto.harga, 10)
          : createProdukDto.harga;

      const jumlah =
        typeof createProdukDto.jumlah === 'string'
          ? parseInt(createProdukDto.jumlah, 10)
          : createProdukDto.jumlah;

      if (isNaN(harga)) {
        throw new Error('Harga harus berupa angka yang valid');
      }

      const newProduk = await this.prisma.produk.create({
        data: {
          jumlah: jumlah,
          nama: createProdukDto.nama,
          harga: harga, // ✅ Sekarang sebagai Int
          tanggal_masuk: createProdukDto.tanggal_masuk, // Menyimpan tanggal masuk saat ini
        },
      });

      console.log('🟢 [Produk Service] Produk created:', newProduk);
      return newProduk;
    } catch (error) {
      console.error(
        '🔴 [Produk Service] Error creating produk:',
        error.message,
      );
      throw error;
    }
  }

  async findAll() {
    try {
      const produks = await this.prisma.produk.findMany();
      return produks;
    } catch (error) {
      console.error(
        '🔴 [Produk Service] Error finding produks:',
        error.message,
      );
      throw error;
    }
  }

  async findOne(id: number) {
    try {
      const produk = await this.prisma.produk.findUnique({
        where: { id },
      });
      if (!produk) {
        throw new Error('Produk tidak ditemukan');
      }
      return produk;
    } catch (error) {
      console.error('🔴 [Produk Service] Error finding produk:', error.message);
      throw error;
    }
  }

  async update(id: number, updateProdukDto: UpdateProdukDto) {
    try {
      console.log('🔵 [Produk Service] Updating produk:', id, updateProdukDto);

      // ✅ Parse harga dari string ke int
      const updateData: any = {
        jumlah: updateProdukDto.jumlah,
        nama: updateProdukDto.nama,
        tanggal_masuk: updateProdukDto.tanggal_masuk,
      };

      if (updateProdukDto.harga) {
        const harga =
          typeof updateProdukDto.harga === 'string'
            ? parseInt(updateProdukDto.harga, 10)
            : updateProdukDto.harga;

        if (isNaN(harga)) {
          throw new Error('Harga harus berupa angka yang valid');
        }

        updateData.harga = harga;
      }

      const updatedProduk = await this.prisma.produk.update({
        where: { id },
        data: updateData,
      });

      console.log('🟢 [Produk Service] Produk updated:', updatedProduk);
      return updatedProduk;
    } catch (error) {
      console.error(
        '🔴 [Produk Service] Error updating produk:',
        error.message,
      );
      throw error;
    }
  }

  async remove(id: number) {
    try {
      console.log('🔵 [Produk Service] Deleting produk:', id);

      const deletedProduk = await this.prisma.produk.delete({
        where: { id },
      });

      console.log('🟢 [Produk Service] Produk deleted:', deletedProduk);
      return deletedProduk;
    } catch (error) {
      console.error(
        '🔴 [Produk Service] Error deleting produk:',
        error.message,
      );
      throw error;
    }
  }
}
