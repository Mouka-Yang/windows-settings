#Requires -RunAsAdministrator

########################
# Configure oh-my-posh #
########################

Set-Location -Path  $HOME

# check if git installed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing git for Windows"
    try {
        $gitUri = "https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe"
        $outputPath = "{$HOME}/Downloads/git-install.exe"
        Invoke-WebRequest -Uri  $gitUri -OutFile $outputPath
        & $outputPath
    }
    catch {
        Write-Error $_        
        exit
    }
}
# install pwsh first 
# PowerShell-7.0.0-preview.3-win-x64.msi
Write-Host "Installing powershell core..."
try {
    
    msiexec.exe /package PowerShell-7.0.0-preview.3-win-x64.msi `
        /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 `
        ENABLE_PSREMOTING=1 `
        REGISTER_MANIFEST=1
}
catch {
    Write-Error $_    
    exit
}
# install posh
Write-Host "Installing posh..."

try {
    
    Install-Module posh-git -Scope CurrentUser
    Install-Module oh-my-posh -Scope CurrentUser
}
catch {
    Write-Error $_    
    exit
}

# install powerline fonts (default in $HOME)
Write-Host "Installing powerline fonts..."
try {
    
    git clone https://github.com/powerline/fonts.git
    & ("./fonts/install.ps1")
}
catch {
    write-error $_    
    exit
}

# Start the default settings
# Set-Prompt
# Alternatively set the desired theme:
Set-Theme Agnoster

Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

# configure pwsh profile
Write-Host "Setting up pwsh profile..."

try {
    
    if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
    Add-Content -Path $PROFILE -Value "
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox"
}
catch {
    Write-Error $_    
    exit
}

##########################
#   change computer name #
##########################

$newName = Read-Host 'Please input new computer name (press enter to skip)'
if (![string]::IsNullOrWhiteSpace($newName)) {
    Rename-Computer -NewName $newName -Force
}
