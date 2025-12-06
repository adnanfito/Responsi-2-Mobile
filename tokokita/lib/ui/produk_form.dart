import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String judul;
  late String tombolSubmit;
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  final _tanggalMasukTextboxController = TextEditingController();
  final _jumlahProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.produk != null) {
      judul = "Ubah Produk Adnan";
      tombolSubmit = "UBAH";
      _jumlahProdukTextboxController.text =
          widget.produk!.jumlah?.toString() ?? '';
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
      _hargaProdukTextboxController.text =
          widget.produk!.hargaProduk?.toString() ?? '';
      _tanggalMasukTextboxController.text =
          widget.produk!.tanggalMasuk?.toString() ?? '';
    } else {
      judul = "Tambah Produk Adnan";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaProdukTextField(),
                _hargaProdukTextField(),
                _jumlahProdukTextField(),
                _tanggalMasukTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _jumlahProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Jumlah Produk"),
      keyboardType: TextInputType.number,
      controller: _jumlahProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Jumlah Produk harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Jumlah harus berupa angka";
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Harga harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Harga harus berupa angka";
        }
        return null;
      },
    );
  }

  Widget _tanggalMasukTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Tanggal Masuk",
        hintText: "YYYY-MM-DD",
      ),
      keyboardType: TextInputType.datetime,
      controller: _tanggalMasukTextboxController,
      readOnly: true,
      onTap: _pickDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Tanggal Masuk harus diisi";
        }
        final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (!regex.hasMatch(value)) {
          return "Format tanggal harus YYYY-MM-DD";
        }
        return null;
      },
    );
  }

  Future<void> _pickDate() async {
    DateTime initialDate = DateTime.now();
    if (_tanggalMasukTextboxController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_tanggalMasukTextboxController.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted = picked.toIso8601String().split('T').first;
      setState(() {
        _tanggalMasukTextboxController.text = formatted;
      });
    }
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      child: Text(tombolSubmit),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.produk != null) {
      _ubah();
    } else {
      _simpan();
    }
  }

  void _simpan() {
    setState(() {
      _isLoading = true;
    });

    final int harga = int.parse(_hargaProdukTextboxController.text.trim());
    final int jumlah = int.parse(_jumlahProdukTextboxController.text.trim());

    Produk createProduk = Produk(
      namaProduk: _namaProdukTextboxController.text.trim(),
      hargaProduk: harga,
      jumlah: jumlah,
      tanggalMasuk: _tanggalMasukTextboxController.text.trim(),
    );

    print('🔵 [Simpan] Creating produk: ${createProduk.toJson()}');

    ProdukBloc.addProduk(produk: createProduk).then(
      (value) {
        print('🟢 [Simpan] Success: $value');

        setState(() {
          _isLoading = false;
        });

        if (value && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const ProdukPage(),
            ),
          );
        }
      },
      onError: (error) {
        print('🔴 [Simpan] Error: $error');
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                WarningDialog(description: "Error: $error"),
          );
        }
      },
    );
  }

  void _ubah() {
    setState(() {
      _isLoading = true;
    });

    final int harga = int.parse(_hargaProdukTextboxController.text.trim());
    final int jumlah = int.parse(_jumlahProdukTextboxController.text.trim());

    Produk updateProduk = Produk(
      id: widget.produk!.id,
      jumlah: jumlah,
      namaProduk: _namaProdukTextboxController.text,
      hargaProduk: harga,
      tanggalMasuk: _tanggalMasukTextboxController.text.trim(),
    );

    ProdukBloc.updateProduk(produk: updateProduk).then(
      (value) {
        print('🟢 [Ubah] Success: $value');
        setState(() {
          _isLoading = false;
        });

        if (value && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const ProdukPage(),
            ),
          );
        }
      },
      onError: (error) {
        print('Error ubah: $error');
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => const WarningDialog(
              description: "Permintaan ubah data gagal, silahkan coba lagi",
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _jumlahProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    _tanggalMasukTextboxController.dispose();
    super.dispose();
  }
}
