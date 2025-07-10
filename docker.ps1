# Laravel Docker Management Script for Windows

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

function Start-Environment {
    Write-Host "Starting Laravel Docker Environment..." -ForegroundColor Green
    docker-compose up -d
    Write-Host "Environment started!" -ForegroundColor Green
    Write-Host "Application: http://localhost:8000" -ForegroundColor Yellow
    Write-Host "phpMyAdmin: http://localhost:8080" -ForegroundColor Yellow
}

function Stop-Environment {
    Write-Host "Stopping Laravel Docker Environment..." -ForegroundColor Red
    docker-compose down
    Write-Host "Environment stopped!" -ForegroundColor Red
}

function Restart-Environment {
    Write-Host "Restarting Laravel Docker Environment..." -ForegroundColor Blue
    docker-compose restart
    Write-Host "Environment restarted!" -ForegroundColor Blue
}

function Show-Logs {
    docker-compose logs -f
}

function Enter-Shell {
    docker-compose exec app bash
}

function Invoke-Artisan {
    $artisanArgs = $Arguments -join " "
    docker-compose exec app php artisan $artisanArgs
}

function Invoke-Composer {
    $composerArgs = $Arguments -join " "
    docker-compose exec app composer $composerArgs
}

function Initialize-Setup {
    Write-Host "Setting up Laravel application..." -ForegroundColor Green
    docker-compose up -d --build
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    docker-compose exec app composer install
    Write-Host "Running migrations..." -ForegroundColor Yellow
    docker-compose exec app php artisan migrate
    Write-Host "Setup complete!" -ForegroundColor Green
    Write-Host "Application: http://localhost:8000" -ForegroundColor Yellow
    Write-Host "phpMyAdmin: http://localhost:8080" -ForegroundColor Yellow
}

function Show-Help {
    Write-Host "Laravel Docker Management Script" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\docker.ps1 [command] [arguments]" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor White
    Write-Host "  start     - Start the Docker environment" -ForegroundColor Gray
    Write-Host "  stop      - Stop the Docker environment" -ForegroundColor Gray
    Write-Host "  restart   - Restart the Docker environment" -ForegroundColor Gray
    Write-Host "  logs      - View logs" -ForegroundColor Gray
    Write-Host "  shell     - Access Laravel container shell" -ForegroundColor Gray
    Write-Host "  artisan   - Run artisan commands" -ForegroundColor Gray
    Write-Host "  composer  - Run composer commands" -ForegroundColor Gray
    Write-Host "  setup     - Initial setup (first time)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor White
    Write-Host "  .\docker.ps1 start" -ForegroundColor Gray
    Write-Host "  .\docker.ps1 artisan migrate" -ForegroundColor Gray
    Write-Host "  .\docker.ps1 composer install" -ForegroundColor Gray
}

switch ($Command) {
    "start" { Start-Environment }
    "stop" { Stop-Environment }
    "restart" { Restart-Environment }
    "logs" { Show-Logs }
    "shell" { Enter-Shell }
    "artisan" { Invoke-Artisan }
    "composer" { Invoke-Composer }
    "setup" { Initialize-Setup }
    default { Show-Help }
}
