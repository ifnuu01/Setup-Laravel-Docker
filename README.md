# Environment Pengembangan Laravel Docker

Environment pengembangan Docker yang lengkap untuk aplikasi Laravel dengan semua layanan yang diperlukan termasuk Nginx, MySQL, Redis, phpMyAdmin, MailHog, dan pemrosesan background job.

## 🚀 Layanan yang Tersedia

- **Laravel App** - PHP 8.2-FPM dengan framework Laravel
- **Nginx** - Web server proxy untuk melayani aplikasi
- **MySQL 8** - Database utama
- **Redis** - Penyimpanan cache dan session
- **phpMyAdmin** - Administrasi MySQL berbasis web
- **MailHog** - Tool untuk testing email
- **Queue Worker** - Pemrosesan antrian Laravel
- **Task Scheduler** - Penjadwal tugas cron Laravel

## 📋 Persyaratan

- Docker Desktop terinstall dan berjalan
- Docker Compose v3.8 atau lebih tinggi
- Git (untuk cloning repository)

## 🛠️ Instalasi & Setup

### 1. Clone atau Setup Proyek Laravel Anda

```bash
# Jika Anda belum memiliki proyek Laravel, buat satu di folder src
git clone your-laravel-project.git src
# ATAU buat proyek Laravel baru
mkdir src
cd src
composer create-project laravel/laravel .
```

### 2. Konfigurasi Environment

Buat file `.env` di proyek Laravel Anda (`src/.env`) dengan konfigurasi database berikut:

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

### 3. Build dan Jalankan Environment

```bash
# Build dan jalankan semua container
docker-compose up -d --build

# Atau jalankan di foreground untuk melihat logs
docker-compose up --build
```

### 4. Install Dependencies Laravel

```bash
# Install dependencies Composer
docker-compose exec app composer install

# Generate application key
docker-compose exec app php artisan key:generate

# Jalankan migrasi database
docker-compose exec app php artisan migrate

# Install dependencies NPM (jika diperlukan)
docker-compose exec app npm install
```

## 🌐 Titik Akses

| Layanan              | URL                   | Kredensial                                                                                |
| -------------------- | --------------------- | ----------------------------------------------------------------------------------------- |
| **Aplikasi Laravel** | http://localhost:8000 | -                                                                                         |
| **phpMyAdmin**       | http://localhost:8081 | Username: `laravel`<br>Password: `secret`<br>ATAU<br>Username: `root`<br>Password: `root` |
| **MailHog**          | http://localhost:8025 | -                                                                                         |
| **Database MySQL**   | localhost:3306        | Username: `laravel`<br>Password: `secret`<br>Database: `laravel`                          |
| **Redis**            | localhost:6379        | -                                                                                         |

## 📁 Struktur Proyek

```
laravel-docker/
├── docker-compose.yml          # Konfigurasi layanan Docker
├── Dockerfile                  # Konfigurasi container PHP-FPM
├── nginx/
│   └── default.conf           # Konfigurasi virtual host Nginx
├── src/                       # Kode aplikasi Laravel Anda
└── README.md                  # Dokumentasi ini
```

## 🔧 Perintah Umum

### Operasi Docker

```bash
# Jalankan semua layanan
docker-compose up -d

# Hentikan semua layanan
docker-compose down

# Lihat logs
docker-compose logs -f

# Lihat logs untuk layanan tertentu
docker-compose logs -f app

# Rebuild containers
docker-compose up -d --build

# Hapus semuanya (containers, networks, volumes)
docker-compose down -v --remove-orphans
```

### Operasi Laravel

```bash
# Akses shell container Laravel
docker-compose exec app bash

# Jalankan perintah Artisan
docker-compose exec app php artisan migrate
docker-compose exec app php artisan make:controller ExampleController
docker-compose exec app php artisan cache:clear

# Install package
docker-compose exec app composer require package-name

# Jalankan tests
docker-compose exec app php artisan test
```

### Operasi Database

```bash
# Akses shell MySQL
docker-compose exec db mysql -u laravel -p

# Import database dump
docker-compose exec -T db mysql -u laravel -p laravel < database.sql

# Buat backup database
docker-compose exec db mysqldump -u laravel -p laravel > backup.sql
```

## 🔍 Detail Layanan

### Container PHP-FPM (app)

- **Base Image**: php:8.2-fpm
- **Extensions**: PDO MySQL, mbstring, zip, exif, pcntl, bcmath, gd
- **Tools**: Composer, cron, supervisor
- **Volume**: `./src:/var/www/html`

### Container Nginx

- **Base Image**: nginx:alpine
- **Port**: 8000 → 80
- **Konfigurasi**: Virtual host khusus untuk Laravel

### Container MySQL

- **Base Image**: mysql:8
- **Port**: 3306
- **Database**: laravel
- **User**: laravel / secret
- **Root Password**: root

### Container Redis

- **Base Image**: redis:alpine
- **Port**: 6379

### Queue Worker

- Secara otomatis memproses job antrian Laravel
- Menjalankan `php artisan queue:work` secara terus-menerus

### Task Scheduler

- Menjalankan tugas terjadwal Laravel setiap menit
- Mengeksekusi `php artisan schedule:run`

## 🚨 Troubleshooting

### Masalah Umum

**Container tidak mau start:**

```bash
# Cek logs container
docker-compose logs app

# Cek apakah port sudah digunakan
netstat -tulpn | grep :8000
```

**Masalah koneksi database:**

```bash
# Pastikan container DB berjalan
docker-compose ps

# Cek logs database
docker-compose logs db

# Verifikasi konfigurasi .env Laravel
docker-compose exec app cat .env | grep DB_
```

**Masalah permission:**

```bash
# Perbaiki permission Laravel storage
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

**Masalah Composer/NPM:**

```bash
# Clear cache Composer
docker-compose exec app composer clear-cache

# Install dependencies
docker-compose exec app composer install --no-dev --optimize-autoloader
```

### Perintah Berguna untuk Debugging

```bash
# Cek status container
docker-compose ps

# Inspeksi container
docker-compose exec app ls -la /var/www/html

# Cek konfigurasi PHP
docker-compose exec app php -m

# Test koneksi database
docker-compose exec app php artisan tinker
# Kemudian jalankan: DB::connection()->getPdo();
```

## 🔄 Alur Kerja Pengembangan

1. **Buat perubahan kode** di direktori `src/`
2. **Perubahan otomatis tercermin** karena volume mounting
3. **Jalankan migrations/seeders** jika diperlukan:
   ```bash
   docker-compose exec app php artisan migrate:fresh --seed
   ```
4. **Monitor logs** untuk masalah apapun:
   ```bash
   docker-compose logs -f app nginx
   ```

## 📦 Menambahkan Layanan Baru

Untuk menambahkan layanan baru, edit `docker-compose.yml`:

```yaml
elasticsearch:
  image: elasticsearch:7.14.0
  container_name: laravel-elasticsearch
  environment:
    - discovery.type=single-node
  ports:
    - "9200:9200"
  networks:
    - app-network
```

## 🔒 Pertimbangan Production

Setup ini dirancang untuk pengembangan. Untuk production:

1. Hapus layanan phpMyAdmin dan MailHog
2. Gunakan environment variables untuk data sensitif
3. Konfigurasi SSL certificate yang proper
4. Setup logging dan monitoring yang proper
5. Gunakan konfigurasi MySQL yang siap production
6. Implementasikan strategi backup yang proper

## 📝 Lisensi

Konfigurasi Docker ini bersifat open-source. Lisensi aplikasi Laravel Anda mungkin berbeda.

## 🤝 Kontribusi

Silakan submit issues dan enhancement requests!
