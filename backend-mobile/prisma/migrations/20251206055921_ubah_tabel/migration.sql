/*
  Warnings:

  - You are about to drop the column `kode_produk` on the `produk` table. All the data in the column will be lost.
  - You are about to drop the column `nama_produk` on the `produk` table. All the data in the column will be lost.
  - Added the required column `jumlah` to the `produk` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nama` to the `produk` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "produk_kode_produk_key";

-- AlterTable
ALTER TABLE "produk" DROP COLUMN "kode_produk",
DROP COLUMN "nama_produk",
ADD COLUMN     "jumlah" INTEGER NOT NULL,
ADD COLUMN     "nama" TEXT NOT NULL;
