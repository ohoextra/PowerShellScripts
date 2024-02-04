# Use Powershell ISE - & "C:\GDrive Mirror\Tekst & Tabel\Configuration & Management\DeleteEmptyDirectories.ps1" -rootDirectory "C:\GDrive Mirror\Afbeelding\NSFW\Belle Delphine" -Verbose

param (
    [string]$rootDirectory
)

# Get all directories in the root directory
$directories = Get-ChildItem -Path $rootDirectory -Recurse -Directory

# Reverse the order of the directories to delete child directories first
$directories = $directories | Sort-Object -Descending -Property FullName

# Calculate total number of directories for progress bar
$totalDirectories = $directories.Count
$currentDirectory = 0

# Log start of script execution
Write-Host "Script execution started."

# Iterate through each directory
foreach ($directory in $directories) {
    # Check if the directory is empty
    $childDirectories = Get-ChildItem -Path $directory.FullName -Recurse -Force -Directory
    if ($childDirectories.Count -eq 0) {
        # Update status
        $currentDirectory++
        Write-Host "Deleting empty directory: $($directory.FullName) ($currentDirectory of $totalDirectories directories deleted)"

        # Remove the directory
        Remove-Item -Path $directory.FullName -Force -Recurse -Verbose
    }
    else {
        # Output verbose message if directory is not empty
        Write-Host "Skipping non-empty directory: $($directory.FullName)"
    }
}

# Log end of script execution
Write-Host "Script execution completed. All empty directories have been deleted."