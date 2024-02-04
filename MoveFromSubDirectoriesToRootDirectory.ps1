# Use Powershell ISE - & ".\MoveFromSubDirectoriesToRootDirectory.ps1" -sourcePath "C:\Root"

param (
    [string]$sourcePath
)

# Get all files in all subdirectories
$files = Get-ChildItem -Path $sourcePath -Recurse -File

# Calculate total number of files for progress bar
$totalFiles = $files.Count
$currentFile = 0
$totalScannedSubdirectories = 0

foreach ($file in $files) {
    # Update progress bar
    $currentFile++
    $currentScannedSubdirectories = @(Get-ChildItem -Path $file.Directory.FullName -Recurse -File).Count
    if ($currentScannedSubdirectories -eq 0) {
        $currentScannedSubdirectories = 1  # to avoid division by zero
    }
    $progressPercentage = ($currentFile / $totalFiles) * 100
    $progressStatus = "$currentFile of $totalFiles files moved | Scanned $currentScannedSubdirectories subdirectories"
    Write-Progress -Activity "Moving files..." -Status $progressStatus -PercentComplete $progressPercentage

    # Ensure the destination file path doesn't exist before moving
    if (!(Test-Path -Path "$sourcePath\$($file.Name)")) {
        Move-Item -Path $file.FullName -Destination $sourcePath
    } else {
        Remove-Item -Path $file.FullName
    }
}

Write-Host "All files have been moved."
