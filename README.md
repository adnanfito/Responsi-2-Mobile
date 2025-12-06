# TokoKita - Mobile Application

## 📋 Informasi Pribadi

| Keterangan | Detail |
|-----------|--------|
| **Nama** | Adnan Fito Dharmawan |
| **NIM** | H1D022054 |
| **Shift Baru** | A |
| **Shift Asal** | E |

---

## 🎥 Demo Aplikasi

https://github.com/user-attachments/assets/6e33c716-7b56-4f1b-9c4a-aa6025b3ae15

---

## 📱 Deskripsi Aplikasi

TokoKita adalah aplikasi mobile yang dibangun menggunakan **Flutter** untuk platform Android dan iOS. Aplikasi ini didukung oleh backend **NestJS** yang menyediakan API untuk manajemen toko dan transaksi.

### Fitur Utama:
- Manajemen produk toko
- Sistem transaksi dan penjualan
- Integrasi dengan backend API
- Interface yang user-friendly

---

## 🛠️ Teknologi yang Digunakan

### Frontend (Mobile)
- **Framework**: Flutter
- **Language**: Dart

### Backend
- **Framework**: NestJS
- **Language**: TypeScript/JavaScript
- **Database**: PostgreeSQL
- **ORM**: Prisma

---

## 📡 Spesifikasi API

Berikut adalah daftar endpoint API yang digunakan dalam aplikasi:

| Method | Endpoint | Deskripsi | Request Body | Response |
|--------|----------|-----------|--------------|----------|
| GET | `/api/products` | Mendapatkan daftar semua produk | - | Array of products |
| GET | `/api/products/:id` | Mendapatkan detail produk berdasarkan ID | - | Product object |
| POST | `/api/products` | Membuat produk baru | `{ name, price, description, category }` | Product object |
| PUT | `/api/products/:id` | Memperbarui data produk | `{ name, price, description, category }` | Product object |
| DELETE | `/api/products/:id` | Menghapus produk | - | `{ message: "Product deleted" }` |
| GET | `/api/transactions` | Mendapatkan daftar semua transaksi | - | Array of transactions |
| POST | `/api/transactions` | Membuat transaksi baru | `{ products, total, userId }` | Transaction object |
| GET | `/api/users` | Mendapatkan daftar pengguna | - | Array of users |
| POST | `/api/auth/login` | Login pengguna | `{ email, password }` | `{ token, user }` |
| POST | `/api/auth/register` | Registrasi pengguna baru | `{ name, email, password }` | `{ token, user }` |

---

## 📝 Penjelasan Kode

### 1. Main.dart (Frontend - Flutter)

**Fungsi**: Entry point aplikasi Flutter yang mengatur konfigurasi awal aplikasi.

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key?  key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita',
      theme: ThemeData(
        primarySwatch: Colors. blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
```

**Penjelasan**:
- `main()`: Fungsi utama yang dijalankan saat aplikasi dimulai
- `MyApp`: Widget root aplikasi yang mengatur tema dan halaman awal
- `MaterialApp`: Widget yang menyediakan material design
- `home`: Menentukan halaman pertama yang ditampilkan

---

### 2. Product Model (Frontend)

**Fungsi**: Mendefinisikan struktur data produk di aplikasi mobile.

```dart
class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String category;

  Product({
    required this. id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price']. toDouble(),
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
    };
  }
}
```

**Penjelasan**:
- `Product`: Class yang merepresentasikan data produk
- `fromJson()`: Method untuk mengkonversi JSON dari API menjadi object Dart
- `toJson()`: Method untuk mengkonversi object Dart menjadi JSON
- `required`: Keyword untuk parameter yang wajib diisi

---

### 3.  Product Service (Frontend)

**Fungsi**: Service untuk menangani komunikasi HTTP dengan backend API.

```dart
class ProductService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response. statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }
}
```

**Penjelasan**:
- `baseUrl`: URL dasar untuk API backend
- `getProducts()`: Mengambil semua produk dari API
- `getProductById()`: Mengambil produk berdasarkan ID
- `createProduct()`: Membuat produk baru di backend
- `async/await`: Untuk menangani operasi asynchronous

---

### 4. App Module (Backend - NestJS)

**Fungsi**: Modul utama yang mengonfigurasi aplikasi NestJS.

```typescript
import { Module } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';
import { ProductController } from './product/product.controller';
import { ProductService } from './product/product. service';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';

@Module({
  imports: [],
  controllers: [ProductController, AuthController],
  providers: [ProductService, AuthService, PrismaService],
})
export class AppModule {}
```

**Penjelasan**:
- `@Module()`: Decorator untuk mendeklarasikan modul
- `imports`: Modul lain yang digunakan
- `controllers`: Controller yang menangani request HTTP
- `providers`: Service dan provider yang disediakan modul

---

### 5.  Product Controller (Backend)

**Fungsi**: Menangani request HTTP untuk endpoint produk.

```typescript
import { Controller, Get, Post, Put, Delete, Body, Param } from '@nestjs/common';
import { ProductService } from './product. service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

@Controller('api/products')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Get()
  findAll() {
    return this.productService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.productService.findOne(+id);
  }

  @Post()
  create(@Body() createProductDto: CreateProductDto) {
    return this.productService.create(createProductDto);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateProductDto: UpdateProductDto) {
    return this.productService.update(+id, updateProductDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.productService.remove(+id);
  }
}
```

**Penjelasan**:
- `@Controller()`: Decorator untuk mendeklarasikan controller
- `@Get()`, `@Post()`, `@Put()`, `@Delete()`: Decorator untuk HTTP methods
- `@Param()`: Untuk mengambil parameter dari URL
- `@Body()`: Untuk mengambil data dari request body
- Dependency Injection: `productService` disuntikkan melalui constructor

---

### 6. Product Service (Backend)

**Fungsi**: Business logic untuk operasi produk. 

```typescript
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

@Injectable()
export class ProductService {
  constructor(private prisma: PrismaService) {}

  create(createProductDto: CreateProductDto) {
    return this.prisma.product.create({
      data: createProductDto,
    });
  }

  findAll() {
    return this.prisma.product.findMany();
  }

  findOne(id: number) {
    return this.prisma.product.findUnique({
      where: { id },
    });
  }

  update(id: number, updateProductDto: UpdateProductDto) {
    return this.prisma. product.update({
      where: { id },
      data: updateProductDto,
    });
  }

  remove(id: number) {
    return this. prisma.product.delete({
      where: { id },
    });
  }
}
```

**Penjelasan**:
- `@Injectable()`: Decorator untuk mendeklarasikan service
- `PrismaService`: ORM untuk interaksi dengan database
- `create()`: Membuat record baru di database
- `findAll()`: Mengambil semua record
- `findOne()`: Mengambil record berdasarkan ID
- `update()`: Mengubah record
- `remove()`: Menghapus record

---

### 7.  Prisma Service (Backend)

**Fungsi**: Service untuk mengelola koneksi database menggunakan Prisma ORM.

```typescript
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

**Penjelasan**:
- `PrismaClient`: Client untuk mengakses database
- `OnModuleInit`: Lifecycle hook saat modul diinisialisasi
- `OnModuleDestroy`: Lifecycle hook saat modul dihancurkan
- `$connect()`: Membuat koneksi ke database
- `$disconnect()`: Menutup koneksi database

---

### 8. Auth Service (Backend)

**Fungsi**: Menangani autentikasi pengguna.

```typescript
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register. dto';
import { LoginDto } from './dto/login. dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService) {}

  async register(registerDto: RegisterDto) {
    const hashedPassword = await bcrypt. hash(registerDto.password, 10);
    return this.prisma.user.create({
      data: {
        ... registerDto,
        password: hashedPassword,
      },
    });
  }

  async login(loginDto: LoginDto) {
    const user = await this. prisma.user.findUnique({
      where: { email: loginDto.email },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const passwordValid = await bcrypt.compare(loginDto.password, user.password);
    if (!passwordValid) {
      throw new Error('Invalid password');
    }

    return user;
  }
}
```

**Penjelasan**:
- `register()`: Mendaftarkan user baru dengan password yang di-hash
- `bcrypt.hash()`: Mengenkripsi password untuk keamanan
- `login()`: Memverifikasi kredensial pengguna
- `bcrypt.compare()`: Membandingkan password input dengan hash di database

---

## 🚀 Cara Menjalankan Aplikasi

### Frontend (Flutter)
```bash
cd tokokita
flutter pub get
flutter run
```

### Backend (NestJS)
```bash
cd backend-mobile
pnpm install
pnpm run start:dev
```

---
---

Sekarang saya akan membuat file README ini di repository Anda:
