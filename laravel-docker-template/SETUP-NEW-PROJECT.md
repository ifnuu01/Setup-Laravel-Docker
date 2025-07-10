# TEMPLATE untuk Project Laravel Baru

## Quick Setup untuk Project Baru

### 1. Copy Template

```powershell
# Copy folder template ke project Laravel baru
cp -r laravel-docker-template/* your-new-laravel-project/
```

### 2. Sesuaikan Konfigurasi

**Edit docker-compose.yml:**

```yaml
# Ganti nama database
environment:
  MYSQL_DATABASE: your_project_db    # ⚠️ GANTI INI

# Ganti container names (opsional)
container_name: yourproject-app      # ⚠️ GANTI INI
container_name: yourproject-nginx    # ⚠️ GANTI INI
container_name: yourproject-mysql    # ⚠️ GANTI INI
container_name: yourproject-phpmyadmin # ⚠️ GANTI INI

# Jika project lama masih jalan, ganti ports:
ports:
  - "8001:80"    # Laravel (dari 8000)
  - "8081:80"    # phpMyAdmin (dari 8080)
  - "3307:3306"  # MySQL (dari 3306)
```

**Edit .env project baru:**

```env
# Sesuaikan dengan database name di docker-compose.yml
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=your_project_db    # ⚠️ SAMA dengan docker-compose.yml
DB_USERNAME=laravel
DB_PASSWORD=secret
```

### 3. Jalankan Setup

```powershell
cd your-new-laravel-project
.\docker.ps1 setup
```

## Contoh Multiple Projects

```
D:\projects\
├── notes-api\              # Project 1 (Port 8000, 8080, 3306)
│   ├── docker-compose.yml # DB: notes_api_db
│   └── ...
├── ecommerce\              # Project 2 (Port 8001, 8081, 3307)
│   ├── docker-compose.yml # DB: ecommerce_db
│   └── ...
└── blog\                   # Project 3 (Port 8002, 8082, 3308)
    ├── docker-compose.yml # DB: blog_db
    └── ...
```

**Project 1 - notes-api (docker-compose.yml):**

```yaml
environment:
    MYSQL_DATABASE: notes_api_db
ports:
    - "8000:80"
    - "8080:80"
    - "3306:3306"
```

**Project 2 - ecommerce (docker-compose.yml):**

```yaml
environment:
    MYSQL_DATABASE: ecommerce_db
ports:
    - "8001:80"
    - "8081:80"
    - "3307:3306"
```

**Project 3 - blog (docker-compose.yml):**

```yaml
environment:
    MYSQL_DATABASE: blog_db
ports:
    - "8002:80"
    - "8082:80"
    - "3308:3306"
```

## Database Independence

✅ **Setiap project punya database terpisah**
✅ **Tidak ada konflik data**
✅ **Mudah di-backup per project**
✅ **Bisa jalan bersamaan** (dengan port berbeda)

## Akses Applications

| Project   | Laravel URL           | phpMyAdmin URL        | MySQL Port |
| --------- | --------------------- | --------------------- | ---------- |
| notes-api | http://localhost:8000 | http://localhost:8080 | 3306       |
| ecommerce | http://localhost:8001 | http://localhost:8081 | 3307       |
| blog      | http://localhost:8002 | http://localhost:8082 | 3308       |

Begini mudahnya setup project Laravel baru! 🚀
