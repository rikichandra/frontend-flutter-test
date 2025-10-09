# 📱 Qtasnim Employee App

**Aplikasi Manajemen Karyawan dengan Clean Architecture dan Hybrid Data Source**

---

## 🎯 Ringkasan Project

Aplikasi manajemen karyawan yang dibangun menggunakan Flutter dengan implementasi Clean Architecture. Aplikasi ini menggabungkan data dari API eksternal dengan penyimpanan lokal, memungkinkan operasi CRUD lengkap secara offline dengan kemampuan sinkronisasi manual.

## 📸 Screenshot Aplikasi

| Home | Add | Edit |
|------|-----|------|
| ![Home](screenshots/home.png) | ![Add](screenshots/add.png) | ![Edit](screenshots/edit.png) |


## ✨ Fitur Utama

- **Clean Architecture** - Pemisahan layer yang jelas (Domain, Data, Presentation)
- **Hybrid Data Source** - Kombinasi API dan Local Storage
- **CRUD Lengkap** - Create, Read, Update, Delete pada data lokal
- **Offline-First** - Bekerja penuh tanpa koneksi internet
- **Manual Sync** - Sinkronisasi data dari API sesuai kebutuhan
- **Search & Filter** - Pencarian karyawan real-time
- **Material 3 Design** - UI modern dan responsif

## 🏗️ Arsitektur

### **Domain Layer** (Business Logic)
```
├── Entities (Employee)
├── Repositories (Abstract Interface)
└── Use Cases
    ├── GetEmployees
    ├── AddEmployee
    ├── UpdateEmployee
    ├── DeleteEmployee
    └── SyncEmployeesFromApi
```

### **Data Layer** (Data Management)
```
├── Models (EmployeeModel dengan Hive)
├── Data Sources
│   ├── Local (Hive Database)
│   └── Remote (API JSONPlaceholder)
└── Repository Implementation
```

### **Presentation Layer** (UI)
```
├── BLoC (State Management)
├── Pages (Employee List, Add/Edit)
└── Widgets (Reusable Components)
```

## 🔄 Alur Data Hybrid

### **Pemuatan Awal**
- **Launch pertama**: Otomatis fetch data dari API → simpan ke Hive
- **Launch berikutnya**: Load langsung dari Hive (lebih cepat)

### **Operasi CRUD**
Semua operasi dilakukan **hanya pada local storage**:
- ✏️ **CREATE** - ID lokal unik (timestamp-based)
- 📖 **READ** - Data dari Hive
- 🔄 **UPDATE** - Simpan perubahan ke Hive
- 🗑️ **DELETE** - Hapus dari Hive

### **Sinkronisasi Manual**
- Tombol **Sync (🔄)** di app bar
- Fetch data terbaru dari API
- Data lokal user tetap dipertahankan

## 🛠️ Tech Stack

| Teknologi | Fungsi |
|-----------|--------|
| **Flutter** | Framework UI |
| **Hive** | Local Database |
| **Dio** | HTTP Client |
| **flutter_bloc** | State Management |
| **get_it** | Dependency Injection |

## 🚀 Cara Menjalankan

```bash
# Clone repository
git clone [repository-url]

# Install dependencies
flutter pub get

# Run aplikasi
flutter run
```

## 💡 Highlight Implementasi

### **1. Local ID Generation**
```dart
int generateLocalId() => DateTime.now().millisecondsSinceEpoch;
```
Menggunakan timestamp untuk menghindari konflik dengan ID API (1-10).

### **2. API Integration**
- **Endpoint**: `https://jsonplaceholder.typicode.com/users`
- **Penggunaan**: Read-only untuk bootstrap awal dan sync
- **Mapping**: Data user API → struktur employee

### **3. Offline Capability**
- ✅ CRUD tanpa internet
- ✅ Data persisten
- ✅ Search offline
- ✅ Hanya sync butuh koneksi

## 📝 Cara Penggunaan

| Aksi | Cara |
|------|------|
| **Tambah** | Tap tombol **+** → isi form → simpan |
| **Edit** | Tap card karyawan → ubah data → simpan |
| **Hapus** | Long press card → konfirmasi hapus |
| **Sync** | Tap tombol **🔄** → konfirmasi sync |
| **Cari** | Gunakan search bar di atas list |

---

## 📌 Catatan Teknis

**Technical Test Submission**  
Project ini dibuat sebagai bagian dari technical test dengan fokus pada:
- Implementasi Clean Architecture yang proper
- Pemahaman tentang state management (BLoC)
- Kemampuan integrasi API dan local storage
- Best practices dalam Flutter development

---

*Dibuat dengan ❤️ menggunakan Flutter & Clean Architecture*