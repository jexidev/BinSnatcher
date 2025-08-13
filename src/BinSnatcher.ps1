# Define source and destination folders
$sourceFolder = ""
$destinationFolder = ""

# Define folder to exclude
$excludedFolder = ""

# Create destination folder if it doesn't exist
if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder
}

# Get all .bin files recursively, excluding the specified folder
$binFiles = Get-ChildItem -Path $sourceFolder -Recurse -Filter *.bin | Where-Object {
    $_.DirectoryName -notlike "$excludedFolder*"
}

foreach ($file in $binFiles) {
    $destinationPath = Join-Path $destinationFolder $file.Name

    # Check if file already exists in destination
    if (-not (Test-Path $destinationPath)) {
        Move-Item -Path $file.FullName -Destination $destinationPath
        Write-Host "Moved: $($file.FullName) → $destinationPath"
    } else {
        Write-Host "Skipped (already exists): $($file.FullName)"
    }
}
