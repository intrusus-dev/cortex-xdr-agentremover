param(
    [Parameter(Mandatory=$true, HelpMessage="Enter the full path to the MSI installer.")]
    [string]$msiPath,

    [Parameter(Mandatory=$true, HelpMessage="Enter the full path to the XDR Agent cleaner.")]
    [string]$cleanerPath,

    [Parameter(Mandatory=$true, HelpMessage="Enter the uninstall password.")]
    [string]$uninstallPw
)

# Variables
$xdrPath = "C:\Program Files\Palo Alto Networks\Traps"
$logPath = "C:\Temp\Cortex\uninstall.log"
$cleanerLogPath = "C:\Temp\Cortex\xdrcleaner.log"

# Ensure administrative privileges
function CheckAdminRights {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "Please run this script as an Administrator!"
        exit
    }
}

# Ensure necessary directories exist
function Ensure-DirectoriesExist {
    $path = Split-Path -Path $logPath -Parent
    if (-not (Test-Path -Path $path)) {
        New-Item -Path $path -ItemType Directory
        Write-Output "Created directory: $path"
    }
}

# Disable tamper protection
function DisableTamperProtection {
    $securePassword = ConvertTo-SecureString $uninstallPw -AsPlainText -Force
    $cytoolPath = "$xdrPath\cytool.exe"
    Write-Output "Disabling tamper protection..."
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $cytoolPath
    $processInfo.RedirectStandardInput = $true
    $processInfo.UseShellExecute = $false
    $processInfo.Arguments = "protect disable"
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null
    $process.StandardInput.WriteLine("test")
    $process.StandardInput.Close()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) {
        Write-Error "Failed to disable tamper protection. Exit Code: $($process.ExitCode)"
       # exit
    }
}

# Function to clean up using XDR Agent Cleaner
function UseXdrAgentCleaner {
    Write-Output "Using XDR Agent Cleaner as a fallback..."
    $quotedCleanerPath = "`"$cleanerPath`""  # Ensure the path is quoted
    $cleanerArguments = "--silent --password $uninstallPw --log $cleanerLogPath"
    $cleanerCommand = "$quotedCleanerPath $cleanerArguments"

    # Using Start-Process to invoke the cleaner
    try {
        $cleanerResult = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cleanerCommand" -NoNewWindow -Wait -PassThru
        if ($cleanerResult.ExitCode -eq 0) {
            Write-Output "Cleaner executed successfully."
        } else {
            Write-Output "Cleaner failed with Exit Code: $($cleanerResult.ExitCode)."
        }
    } catch {
        Write-Error "An error occurred while running the cleaner: $_"
    }
}

# Uninstall MSI
function UninstallMSI {
    Write-Output "Attempting to silently uninstall Cortex XDR agent using msiexec..."
    $msiExecCommand = "msiexec /x `"$msiPath`" /qn /l*v `"$logPath`" UNINSTALL_PASSWORD=$uninstallPw"
    $msiResult = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $msiExecCommand" -NoNewWindow -Wait -PassThru
    if ($msiResult.ExitCode -eq 0) {
        Write-Output "Silent uninstallation via MSI successful."
    } else {
        Write-Output "Silent MSI uninstall failed with Exit Code: $($msiResult.ExitCode)."
        UseXdrAgentCleaner
    }
}

# Main execution
CheckAdminRights
Ensure-DirectoriesExist
DisableTamperProtection
UninstallMSI
