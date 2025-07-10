# 🚀 Laravel + Docker Setup untuk Windows

Halo! Ini adalah setup lengkap untuk menjalankan Laravel dengan Docker di Windows. Gak perlu pusing install PHP, MySQL, dan Nginx satu-satu - semuanya udah dikemas rapi dalam Docker containers.

## 📋 Yang Perlu Disiapkan Dulu

Pastikan udah install ini semua ya:

- ✅ **Docker Desktop for Windows** - [Download disini](https://www.docker.com/products/docker-desktop)
- ✅ **Git** - [Download disini](https://git-scm.com/download/win)
- ✅ **Composer** - [Download disini](https://getcomposer.org/download/) (untuk bikin project Laravel baru)
- ✅ **PowerShell** - Biasanya udah ada di Windows

## 🎯 Setup Project Laravel Baru (Step by Step)

### 1. Bikin Project Laravel Baru

```powershell
# Bikin project Laravel baru
composer create-project laravel/laravel nama-project-kamu
cd nama-project-kamu
```

### 2. Copy Semua File Docker

Copy semua file dari repository ini ke folder project Laravel kamu:

```
📁 nama-project-kamu/
├── 📄 Dockerfile                    # ← Copy ini
├── 📄 docker-compose.yml           # ← Copy ini
├── 📄 .dockerignore                # ← Copy ini
├── 📄 docker.ps1                   # ← Copy ini
├── 📄 optimize.ps1                 # ← Copy ini
└── 📁 docker-compose/              # ← Copy folder ini
    ├── 📁 nginx/
    │   └── 📄 default.conf
    └── 📁 mysql/
        └── 📄 my.cnf
```

### 3. Setting File .env

Edit file `.env` di project Laravel kamu, ganti bagian database jadi begini:

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=laravel
DB_PASSWORD=secret
```

### 4. Jalankan Setup

```powershell
# Kasih permission dulu buat PowerShell script
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Setup lengkap (cukup sekali aja)
.\docker.ps1 setup
```

**Tunggu sampai selesai** (biasanya 2-5 menit tergantung internet), nanti bakal otomatis:

- Download semua Docker images
- Install dependencies Laravel
- Setup database
- Jalankan migration

### 5. Buka Browser

Kalau udah selesai setup, buka:

- 🌐 **Laravel App**: http://localhost:8000
- 🗄️ **phpMyAdmin**: http://localhost:8080

## 📁 Apa Aja Yang Ada Di Setup Ini?

```
📁 project-laravel-kamu/
├── 📄 Dockerfile                    # Recipe untuk bikin PHP container
├── 📄 docker-compose.yml           # Orchestrasi semua services
├── 📄 .dockerignore                # File yang diabaikan saat build
├── 📄 docker.ps1                   # Script helper buat Windows
├── 📄 optimize.ps1                 # Script optimasi performa
├── 📁 docker-compose/
│   ├── 📁 nginx/
│   │   └── 📄 default.conf         # Konfigurasi web server
│   └── 📁 mysql/
│       └── 📄 my.cnf               # Konfigurasi database
└── 📁 laravel-files... (project Laravel kamu)
```

## 🎛️ Services Yang Jalan

| Service       | Port | URL                   | Fungsi                |
| ------------- | ---- | --------------------- | --------------------- |
| 🌐 Laravel    | 8000 | http://localhost:8000 | Aplikasi web kamu     |
| 🗄️ phpMyAdmin | 8080 | http://localhost:8080 | Kelola database       |
| 🐬 MySQL      | 3306 | localhost:3306        | Database server       |
| 🔴 Redis      | 6379 | localhost:6379        | Cache & session store |

## 🔑 Login Database

**Untuk Laravel (.env):**

```env
DB_HOST=db
DB_DATABASE=app
DB_USERNAME=laravel
DB_PASSWORD=secret
```

**Untuk phpMyAdmin atau tools eksternal:**

- 🌐 **Host**: localhost
- 🗄️ **Database**: app
- 👤 **Username**: laravel
- 🔐 **Password**: secret
- 🔑 **Root Password**: rootpassword

## ⚡ Command Yang Sering Dipake

### Jalanin Environment

```powershell
# Start semua container
.\docker.ps1 start

# Stop semua container
.\docker.ps1 stop

# Restart semua container
.\docker.ps1 restart

# Liat logs real-time
.\docker.ps1 logs
```

### Laravel Commands

```powershell
# Masuk ke shell container Laravel
.\docker.ps1 shell

# Jalanin artisan commands
.\docker.ps1 artisan migrate
.\docker.ps1 artisan make:model User
.\docker.ps1 artisan tinker
.\docker.ps1 artisan serve # gak perlu ini, udah jalan otomatis

# Jalanin composer commands
.\docker.ps1 composer install
.\docker.ps1 composer require spatie/laravel-permission
.\docker.ps1 composer dump-autoload
```

### Setup Ulang (Kalau Ada Masalah)

```powershell
# Setup lengkap dari awal
.\docker.ps1 setup

# Optimasi performa
.\optimize.ps1 optimize

# Reset named volumes (kalau vendor error)
.\optimize.ps1 reset
```

## 🔧 Manual Commands (Kalau Mau Pake Docker Langsung)

Kalau mau pake command Docker langsung tanpa script helper:

```powershell
# Start semua services
docker-compose up -d

# Stop semua services
docker-compose down

# Build ulang dan start
docker-compose up -d --build

# Jalanin artisan
docker-compose exec app php artisan migrate

# Jalanin composer
docker-compose exec app composer install

# Masuk ke shell container
docker-compose exec app bash

# Liat logs specific service
docker-compose logs -f app
docker-compose logs -f db
```

## 🚨 Troubleshooting

### 🔴 Port Udah Dipake

Kalau ada error "port already in use", edit `docker-compose.yml`:

```yaml
# Ganti port yang bentrok
services:
  webserver:
    ports:
      - "8001:80" # Ganti dari 8000 ke 8001

  phpmyadmin:
    ports:
      - "8081:80" # Ganti dari 8080 ke 8081

  db:
    ports:
      - "3307:3306" # Ganti dari 3306 ke 3307
```

### 🔴 Permission Error

```powershell
# Fix permission issues
docker-compose exec app chown -R www-data:www-data /var/www
docker-compose exec app chmod -R 755 /var/www/storage
```

### 🔴 Database Connection Error

1. **Pastikan MySQL container udah jalan**:

   ```powershell
   docker-compose ps
   ```

2. **Tunggu MySQL ready** (biasanya 30-60 detik pertama kali):

   ```powershell
   docker-compose logs db
   # Tunggu sampai ada log "ready for connections"
   ```

3. **Cek kredensial di .env** sama dengan docker-compose.yml

### 🔴 Vendor Folder Error

```powershell
# Reset named volumes
.\optimize.ps1 reset

# Atau manual:
docker-compose down
docker volume prune -f
docker-compose up -d --build
.\docker.ps1 composer install
```

### 🔴 Performance Lambat

```powershell
# Optimasi Laravel
.\optimize.ps1 optimize

# Atau manual:
.\docker.ps1 artisan config:cache
.\docker.ps1 artisan route:cache
.\docker.ps1 artisan view:cache
.\docker.ps1 composer dump-autoload --optimize
```

## 📦 Yang Udah Terinstall

### 🐘 PHP Extensions

- `pdo_mysql` - Database MySQL
- `mbstring` - String handling
- `exif` - Image metadata
- `pcntl` - Process control
- `bcmath` - Math calculations
- `gd` - Image processing
- `opcache` - Performance optimization

### 🛠️ Development Tools

- **Composer** - PHP package manager
- **Node.js & npm** - Frontend dependencies
- **Git** - Version control

### 🏗️ Services

- **PHP 8.2 FPM** - PHP processor
- **Nginx (Alpine)** - Web server
- **MySQL 8.0** - Database
- **phpMyAdmin** - Database GUI
- **Redis (Alpine)** - Cache & sessions

## 🎨 Customization (Sesuain Kebutuhan)

### 🔄 Ganti Versi PHP

Edit `Dockerfile`:

```dockerfile
FROM php:8.3-fpm  # Ganti dari 8.2 ke 8.3
```

### ➕ Tambah PHP Extension

Edit `Dockerfile`:

```dockerfile
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd redis imagick
```

### 🔌 Ganti Port

Edit `docker-compose.yml`:

```yaml
services:
  webserver:
    ports:
      - "8001:80" # Laravel
  phpmyadmin:
    ports:
      - "8081:80" # phpMyAdmin
  db:
    ports:
      - "3307:3306" # MySQL
```

### 🗄️ Ganti Database Credentials

Edit `docker-compose.yml`:

```yaml
environment:
  MYSQL_DATABASE: project_baru
  MYSQL_USER: user_baru
  MYSQL_PASSWORD: password_baru
```

Dan jangan lupa update `.env`:

```env
DB_DATABASE=project_baru
DB_USERNAME=user_baru
DB_PASSWORD=password_baru
```

## 📚 Multiple Projects (Kelola Banyak Project)

### 🎯 Scenario 1: Database Terpisah (RECOMMENDED)

Setiap project punya database sendiri - ini yang paling aman dan gampang.

**Langkah untuk project baru:**

1. **Copy semua file Docker** ke project baru
2. **Edit docker-compose.yml** - ganti database name:
   ```yaml
   environment:
     MYSQL_DATABASE: project_kedua_db # Ganti nama
   ```
3. **Ganti port** kalau project lama masih jalan:
   ```yaml
   ports:
     - "8001:80" # Laravel (8000 -> 8001)
     - "8081:80" # phpMyAdmin (8080 -> 8081)
     - "3307:3306" # MySQL (3306 -> 3307)
   ```
4. **Edit .env** project baru:
   ```env
   DB_DATABASE=project_kedua_db
   ```
5. **Jalanin setup**:
   ```powershell
   .\docker.ps1 setup
   ```

**Contoh struktur:**

```
📁 D:\projects\
├── 📁 notes-api\               # Project 1
│   ├── 📄 docker-compose.yml  # Port 8000, DB: notes_db
│   └── ...
├── 📁 ecommerce\               # Project 2
│   ├── 📄 docker-compose.yml  # Port 8001, DB: ecommerce_db
│   └── ...
└── 📁 blog\                   # Project 3
    ├── 📄 docker-compose.yml  # Port 8002, DB: blog_db
    └── ...
```

### 🌐 Scenario 2: Share MySQL Container (ADVANCED)

Kalau mau semua project pake MySQL yang sama (agak ribet tapi bisa):

**Setup MySQL Global:**

```yaml
# docker-compose-mysql.yml (file terpisah)
services:
  mysql-global:
    image: mysql:8.0
    container_name: mysql-global
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - mysql_global_data:/var/lib/mysql
    networks:
      - shared-network

networks:
  shared-network:
    external: true

volumes:
  mysql_global_data:
```

**Setup:**

```powershell
# 1. Buat network global
docker network create shared-network

# 2. Start MySQL global
docker-compose -f docker-compose-mysql.yml up -d

# 3. Bikin database per project
docker exec mysql-global mysql -uroot -prootpassword -e "CREATE DATABASE project1_db;"
docker exec mysql-global mysql -uroot -prootpassword -e "CREATE DATABASE project2_db;"
```

### 💻 Scenario 3: Pake MySQL Yang Udah Ada di Windows

Kalau udah punya MySQL terinstall di Windows:

**Edit .env:**

```env
DB_HOST=host.docker.internal  # Akses localhost dari container
DB_PORT=3306
DB_DATABASE=project_db
DB_USERNAME=root
DB_PASSWORD=mysql_password_kamu
```

**Hapus service MySQL dari docker-compose.yml:**

```yaml
services:
  app:
    # ... config app
  webserver:
    # ... config nginx
  # Hapus bagian db dan phpmyadmin
```

## 💡 Tips & Trik

### ⚡ Performance Tips

```powershell
# Optimasi Laravel cache
.\optimize.ps1 optimize

# Reset kalau ada issue dengan vendor/
.\optimize.ps1 reset

# Install dependencies aja
.\optimize.ps1 install
```

### 🔍 Debug Tips

```powershell
# Liat logs real-time
.\docker.ps1 logs

# Liat logs specific service
docker-compose logs -f app
docker-compose logs -f db
docker-compose logs -f webserver

# Check status semua container
docker-compose ps

# Masuk ke container buat debug
.\docker.ps1 shell
```

### 🏃‍♂️ Development Workflow

```powershell
# 1. Start environment
.\docker.ps1 start

# 2. Buat migration/model
.\docker.ps1 artisan make:migration create_posts_table
.\docker.ps1 artisan make:model Post

# 3. Jalanin migration
.\docker.ps1 artisan migrate

# 4. Install package baru
.\docker.ps1 composer require spatie/laravel-permission

# 5. Clear cache kalau perlu
.\docker.ps1 artisan config:clear
```

## 📋 Next Steps Checklist

1. ✅ Setup Docker environment (`.\docker.ps1 setup`)
2. ✅ Test buka http://localhost:8000
3. ✅ Test buka phpMyAdmin http://localhost:8080
4. ✅ Run migration pertama (`.\docker.ps1 artisan migrate`)
5. 🔄 Mulai develop aplikasi kamu
6. 🔄 Setup authentication (`.\docker.ps1 artisan make:auth`)
7. 🔄 Install packages yang dibutuhin
8. 🔄 Setup CI/CD pipeline
9. 🔄 Deploy ke production

## 🌟 Features Keren Yang Udah Ada

### 🚀 Performance Optimizations

- **OpCache** enabled untuk PHP
- **Gzip compression** di Nginx
- **Static file caching** (js, css, images)
- **Named volumes** untuk vendor/ dan node_modules/
- **FastCGI optimizations**

### 🔒 Security Features

- **Security headers** di Nginx
- **Non-root user** di container
- **Isolated networks**
- **Environment variables** untuk credentials

### 🛠️ Development Tools

- **Hot reload** - file changes langsung kedetect
- **Error logging** - semua error masuk ke logs
- **Database GUI** - phpMyAdmin untuk manage DB
- **Redis support** - buat cache dan sessions

## 📚 Useful Links & Resources

### 📖 Documentation

- [Laravel Documentation](https://laravel.com/docs) - Official Laravel docs
- [Docker Documentation](https://docs.docker.com/) - Learn more about Docker
- [Docker Compose Reference](https://docs.docker.com/compose/) - Compose file reference

### 🎥 Video Tutorials (Bahasa Indonesia)

- [Laravel Docker Series - Parsinta](https://parsinta.com)
- [Docker untuk Laravel - BuildWith Angga](https://buildwithangga.com)

### 🛠️ Tools Yang Berguna

- [Laravel Debugbar](https://github.com/barryvdh/laravel-debugbar) - Debug toolbar
- [Laravel Telescope](https://laravel.com/docs/telescope) - Debug assistant
- [Laravel IDE Helper](https://github.com/barryvdh/laravel-ide-helper) - IDE autocompletion

### 🔌 Extensions Recomended (VS Code)

- **Docker** - Microsoft
- **PHP Intelephense** - Ben Mewburn
- **Laravel Blade Snippets** - Winnie Lin
- **Laravel Artisan** - Ryan Naddy
- **GitLens** - GitKraken

## 🤝 Contributing & Support

Kalau ada bug atau mau improve setup ini:

1. Fork repo ini
2. Bikin branch baru (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add some improvement'`)
4. Push ke branch (`git push origin feature/improvement`)
5. Bikin Pull Request

**🎉 Happy Coding!**

Kalau setup ini membantu, jangan lupa kasih ⭐ ya!
