param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("blue","green")]
    [string]$env
)

$composeFile = "deploy/compose/docker-compose.$env.yml"

Write-Host ""
Write-Host "=== Deploying $env environment ==="
Write-Host "Using compose file: $composeFile"
Write-Host ""

# Pull latest images
docker compose -f $composeFile pull
if ($LASTEXITCODE -ne 0) {
    Write-Host "Pull failed." -ForegroundColor Red
    exit 1
}

# Start or update containers
docker compose -f $composeFile up -d --remove-orphans
if ($LASTEXITCODE -ne 0) {
    Write-Host "Up failed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== $env deployment completed successfully ===" -ForegroundColor Green
Write-Host ""