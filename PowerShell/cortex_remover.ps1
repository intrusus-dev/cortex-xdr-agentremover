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
$taskName = "RunXDRCleanerPostReboot"
$taskAction = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -msiPath `"$msiPath`" -cleanerPath `"$cleanerPath`" -uninstallPw `"$uninstallPw`" -reboot"

# Function to run XDR Agent Cleaner
function RunXdrAgentCleaner {
    Write-Output "Running XDR Agent Cleaner..."
    $cleanerArguments = "--silent --password $uninstallPw --log $cleanerLogPath"
    $cleanerCommand = "`"$cleanerPath`" $cleanerArguments"

    # Using Start-Process to invoke the cleaner
    try {
        $cleanerResult = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cleanerCommand" -NoNewWindow -Wait -PassThru
        if ($cleanerResult.ExitCode -eq 0) {
            Write-Output "Cleaner executed successfully."
        } else {
            Write-Output "Cleaner failed with Exit Code: $($cleanerResult.ExitCode)."
            exit 1
        }
    } catch {
        Write-Error "An error occurred while running the cleaner: $_"
        exit 1
    }
}

# Function to check for and remove the scheduled task if present
function CheckAndRemoveScheduledTask {
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($task) {
        Write-Output "Found scheduled task $taskName. Running cleaner and removing task..."
        # Run Cleaner one more time
        Write-Output "Running XDR Agent Cleaner..."
        $cleanerArguments = "--silent --password $uninstallPw --log $cleanerLogPath"
        $cleanerCommand = "`"$cleanerPath`" $cleanerArguments"
        # Using Start-Process to invoke the cleaner
        try {
            $cleanerResult = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cleanerCommand" -NoNewWindow -Wait -PassThru
            if ($cleanerResult.ExitCode -eq 0) {
                Write-Output "Cleaner executed successfully."
            } else {
                Write-Output "Cleaner failed with Exit Code: $($cleanerResult.ExitCode)."
                exit 1
            }
        } catch {
            Write-Error "An error occurred while running the cleaner: $_"
            exit 1
        }
    }
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        exit 0
}

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

# Function to schedule the XDR Agent Cleaner to run after reboot
function ScheduleCleanerTask {
    Write-Output "Scheduling XDR Agent Cleaner to run when the user logs on..."
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -msiPath `"$msiPath`" -cleanerPath `"$cleanerPath`" -uninstallPw `"$uninstallPw`""
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings
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
        RunXdrAgentCleaner
        ScheduleCleanerTask
        Write-Output "Rebooting the system..."
        Restart-Computer -Force
    }
}

# Main execution
CheckAdminRights
Ensure-DirectoriesExist
CheckAndRemoveScheduledTask
DisableTamperProtection
UninstallMSI
