/*
  Warnings:

  - Added the required column `tanggal_masuk` to the `produk` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "produk" ADD COLUMN     "tanggal_masuk" TEXT NOT NULL;
