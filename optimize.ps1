# Script untuk optimasi performa Laravel Docker

param(
    [Parameter(Position=0)]
    [string]$Command
)

function Optimize-Performance {
    Write-Host "Mengoptimasi performa Laravel..." -ForegroundColor Green
    
    # Clear dan rebuild cache
    docker-compose exec app php artisan config:clear
    docker-compose exec app php artisan route:clear
    docker-compose exec app php artisan view:clear
    docker-compose exec app php artisan cache:clear
    
    # Rebuild cache untuk production
    docker-compose exec app php artisan config:cache
    docker-compose exec app php artisan route:cache
    docker-compose exec app php artisan view:cache
    
    # Optimize composer autoloader
    docker-compose exec app composer dump-autoload --optimize
    
    Write-Host "Optimasi selesai!" -ForegroundColor Green
}

function Install-Dependencies {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    
    # Install composer dependencies
    docker-compose exec app composer install --optimize-autoloader --no-dev
    
    # Install npm dependencies jika ada
    if (Test-Path "package.json") {
        docker-compose exec app npm install
        docker-compose exec app npm run build
    }
    
    Write-Host "Dependencies installed!" -ForegroundColor Green
}

function Reset-Volumes {
    Write-Host "Resetting named volumes..." -ForegroundColor Red
    docker-compose down
    docker volume rm notes-api_vendor_volume notes-api_node_modules_volume notes-api_storage_volume -f
    docker-compose up -d --build
    Install-Dependencies
    Optimize-Performance
    Write-Host "Volumes reset complete!" -ForegroundColor Green
}

function Show-Performance-Tips {
    Write-Host "Tips untuk Performa Docker di Windows:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Pastikan WSL2 backend aktif di Docker Desktop" -ForegroundColor White
    Write-Host "2. Pindahkan project ke dalam WSL2 file system" -ForegroundColor White
    Write-Host "3. Gunakan named volumes untuk vendor/, node_modules/, storage/" -ForegroundColor White
    Write-Host "4. Enable file sharing optimization di Docker Desktop" -ForegroundColor White
    Write-Host "5. Increase memory allocation untuk Docker Desktop" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor White
    Write-Host "  .\optimize.ps1 optimize    - Optimize Laravel cache" -ForegroundColor Gray
    Write-Host "  .\optimize.ps1 install     - Install dependencies" -ForegroundColor Gray
    Write-Host "  .\optimize.ps1 reset       - Reset named volumes" -ForegroundColor Gray
}

switch ($Command) {
    "optimize" { Optimize-Performance }
    "install" { Install-Dependencies }
    "reset" { Reset-Volumes }
    default { Show-Performance-Tips }
}
