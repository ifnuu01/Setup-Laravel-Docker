# Laravel 12 + Docker Setup untuk Windows

Jika sebelumnya belum pernah menggunakan Docker + Laravel 12 di Windows, berikut adalah panduan lengkap untuk setup project Laravel 12 dengan Docker di Windows. Panduan ini mencakup semua langkah dari awal hingga siap digunakan, termasuk setup database MySQL dan phpMyAdmin untuk pertama kali.

Panduan untuk project baru/setup laravel + docker kedua kalinya, serta cara mengelola beberapa project dengan database terpisah atau berbagi MySQL container bisa dilihat di folder laravel-docker-template.

## Prerequisites

- Docker Desktop for Windows
- Git
- PowerShell

## Step-by-Step Setup untuk Project Baru

### 1. Buat Project Laravel Baru

```powershell
composer create-project laravel/laravel nama-project
cd nama-project
```

### 2. Copy Files Docker

Copy semua file berikut ke root directory project Laravel:

- `Dockerfile`
- `docker-compose.yml`
- `.dockerignore`
- `docker.ps1`
- `docker-compose/nginx/default.conf`
- `docker-compose/mysql/my.cnf`

### 3. Update File .env

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
# Berikan permission untuk script PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Setup lengkap (sekali jalan)
.\docker.ps1 setup
```

## Struktur File Docker

```
your-laravel-project/
├── Dockerfile                          # Image definition untuk Laravel
├── docker-compose.yml                  # Orchestrasi semua services
├── .dockerignore                       # File yang diabaikan saat build
├── docker.ps1                          # Script management untuk Windows
├── docker-compose/
│   ├── nginx/
│   │   └── default.conf                # Konfigurasi Nginx
│   └── mysql/
│       └── my.cnf                      # Konfigurasi MySQL
└── ... (files Laravel lainnya)
```

## Services yang Berjalan

| Service     | Port | URL                   | Keterangan          |
| ----------- | ---- | --------------------- | ------------------- |
| Laravel App | 8000 | http://localhost:8000 | Aplikasi Laravel    |
| phpMyAdmin  | 8080 | http://localhost:8080 | Database Management |
| MySQL       | 3306 | localhost:3306        | Database Server     |

## Kredensial Database

- **Host**: db (untuk Laravel), localhost (untuk tools eksternal)
- **Database**: app
- **Username**: laravel
- **Password**: secret
- **Root Password**: rootpassword

## Commands Berguna

```powershell
# Start environment
.\docker.ps1 start

# Stop environment
.\docker.ps1 stop

# Restart environment
.\docker.ps1 restart

# View logs
.\docker.ps1 logs

# Access Laravel container shell
.\docker.ps1 shell

# Run artisan commands
.\docker.ps1 artisan migrate
.\docker.ps1 artisan make:model User

# Run composer commands
.\docker.ps1 composer install
.\docker.ps1 composer require package-name

# Setup lengkap (first time)
.\docker.ps1 setup
```

## Manual Commands (Alternatif)

```powershell
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Build and start
docker-compose up -d --build

# Run artisan
docker-compose exec app php artisan migrate

# Run composer
docker-compose exec app composer install

# Access container shell
docker-compose exec app bash
```

## Troubleshooting

### Port sudah digunakan

Jika port 8000, 8080, atau 3306 sudah digunakan, edit `docker-compose.yml`:

```yaml
ports:
  - "8001:80" # Ganti 8000 jadi 8001
```

### Permission issues

```powershell
# Berikan permission untuk container
docker-compose exec app chown -R www-data:www-data /var/www
```

### Database connection issues

- Pastikan service MySQL sudah running
- Periksa kredensial di file `.env`
- Tunggu beberapa detik setelah start untuk MySQL ready

## What's Included

### PHP Extensions

- pdo_mysql
- mbstring
- exif
- pcntl
- bcmath
- gd

### Tools

- Composer
- Node.js & npm
- Git

### Services

- PHP 8.2 FPM
- Nginx (Alpine)
- MySQL 8.0
- phpMyAdmin

## Customization

### Mengubah versi PHP

Edit `Dockerfile`:

```dockerfile
FROM php:8.3-fpm  # Ganti dari 8.2 ke 8.3
```

### Menambah PHP Extension

Edit `Dockerfile`:

```dockerfile
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd redis
```

### Mengubah port

Edit `docker-compose.yml`:

```yaml
ports:
  - "8001:80" # Laravel
  - "8081:80" # phpMyAdmin
  - "3307:3306" # MySQL
```

### Mengubah database credentials

Edit `docker-compose.yml` dan `.env`:

```yaml
environment:
  MYSQL_DATABASE: my_app
  MYSQL_USER: my_user
  MYSQL_PASSWORD: my_password
```

## Next Steps

1. ✅ Setup Docker environment
2. ✅ Run migrations
3. 🔄 Develop your application
4. 🔄 Add more services if needed (Redis, Elasticsearch, etc.)
5. 🔄 Setup CI/CD pipeline
6. 🔄 Deploy to production

## Useful Links

- [Laravel Documentation](https://laravel.com/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Configuration](https://nginx.org/en/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## Database Management untuk Multiple Projects

### Scenario 1: Project Baru dengan Database Baru (RECOMMENDED)

Setiap project Laravel sebaiknya punya database terpisah untuk menghindari konflik.

**Untuk project baru:**

1. **Copy semua file template** ke project baru
2. **Edit docker-compose.yml** - ganti nama database:

```yaml
environment:
  MYSQL_DATABASE: project_baru_db # Ganti nama database
  MYSQL_USER: laravel
  MYSQL_PASSWORD: secret
```

3. **Edit .env** project baru:

```env
DB_DATABASE=project_baru_db    # Sesuaikan dengan docker-compose.yml
```

4. **Ganti port jika project lama masih jalan:**

```yaml
ports:
  - "8001:80" # Ganti dari 8000 ke 8001 (Laravel)
  - "8081:80" # Ganti dari 8080 ke 8081 (phpMyAdmin)
  - "3307:3306" # Ganti dari 3306 ke 3307 (MySQL)
```

**Contoh struktur multiple projects:**

```
D:\projects\
├── laravel-notes-api\          # Project 1
│   ├── docker-compose.yml     # Port 8000, DB: notes_api_db
│   └── ...
├── laravel-ecommerce\          # Project 2
│   ├── docker-compose.yml     # Port 8001, DB: ecommerce_db
│   └── ...
└── laravel-blog\               # Project 3
    ├── docker-compose.yml     # Port 8002, DB: blog_db
    └── ...
```

### Scenario 2: Sharing MySQL Container (ADVANCED)

Jika ingin share satu MySQL container untuk semua project:

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

**Project Laravel menggunakan MySQL global:**

```yaml
# docker-compose.yml untuk each project
services:
  app:
    # ... app config
    networks:
      - shared-network

  webserver:
    # ... nginx config
    networks:
      - shared-network

networks:
  shared-network:
    external: true
```

**Cara setup:**

```powershell
# 1. Buat network global
docker network create shared-network

# 2. Start MySQL global
docker-compose -f docker-compose-mysql.yml up -d

# 3. Buat database untuk each project
docker exec mysql-global mysql -uroot -prootpassword -e "CREATE DATABASE project1_db;"
docker exec mysql-global mysql -uroot -prootpassword -e "CREATE DATABASE project2_db;"
```

### Scenario 3: Menggunakan Database External

Jika punya MySQL yang sudah terinstall di Windows:

**Edit .env:**

```env
DB_CONNECTION=mysql
DB_HOST=host.docker.internal  # Untuk akses localhost dari container
DB_PORT=3306
DB_DATABASE=project_baru_db
DB_USERNAME=root
DB_PASSWORD=your_mysql_password
```

**Hapus service db dari docker-compose.yml:**

```yaml
services:
  app:
    # ... config app

  webserver:
    # ... config nginx

  # Hapus bagian db dan phpmyadmin jika tidak diperlukan
```

## Recommendation

**Gunakan Scenario 1** (Database terpisah per project) karena:

✅ **Mudah di-manage**
✅ **Tidak ada konflik antar project**
✅ **Mudah di-backup per project**
✅ **Mudah di-deploy**
✅ **Isolasi yang baik**

**Step mudah untuk project baru:**

1. **Copy folder template:**

```powershell
# Copy semua file docker dari project lama
cp -r laravel-notes-api/Dockerfile new-project/
cp -r laravel-notes-api/docker-compose.yml new-project/
cp -r laravel-notes-api/docker.ps1 new-project/
cp -r laravel-notes-api/docker-compose/ new-project/
cp -r laravel-notes-api/.dockerignore new-project/
```

2. **Edit docker-compose.yml project baru:**

```yaml
environment:
  MYSQL_DATABASE: new_project_db # Ganti nama database
ports:
  - "8001:80" # Ganti port jika project lama masih jalan
  - "8081:80" # phpMyAdmin port
  - "3307:3306" # MySQL port
```

3. **Edit .env project baru:**

```env
DB_DATABASE=new_project_db
```

4. **Run setup:**

```powershell
cd new-project
.\docker.ps1 setup
```

Jika bingung di langkah-langkah ini, bisa lihat contoh di folder `laravel-docker-template` yang sudah disiapkan.

**Selesai!** Project baru sudah punya database sendiri dan berjalan di port berbeda
