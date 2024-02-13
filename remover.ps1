# Step 1: Define the path to the XDR Agent Cleaner executable and temporary extraction directory
$XdrCleanerZip = "C:\path\to\XDR Cleaner.zip"
$TempDir = "C:\temp\XdrCleaner"
$XdrCleanerExe = "$TempDir\XdrAgentCleaner.exe"
$LogPath = "$TempDir\CleanerLog.log"

# Ensure the temporary directory exists
New-Item -ItemType Directory -Force -Path $TempDir

# Extract the XDR Cleaner zip file
Expand-Archive -LiteralPath $XdrCleanerZip -DestinationPath $TempDir -Force

# Step 2: Run XdrAgentCleaner.exe with admin rights for the first time
Start-Process -FilePath $XdrCleanerExe -ArgumentList "--silent", "--log `"$LogPath`"" -NoNewWindow -Wait -Verb RunAs

# Step 3: Reboot the machine
Restart-Computer -Force
# IMPORTANT: The script execution will stop here, and you need to rerun the script after the reboot to complete the next steps.

# Step 4: After reboot, check if script needs to run the cleaner a second time
# This part of the script should only be executed after the system reboots. You might need to schedule this script to run after reboot automatically.
Start-Process -FilePath $XdrCleanerExe -ArgumentList "--silent", "--log `"$LogPath`"" -NoNewWindow -Wait -Verb RunAs

# Cleaning up the temporary directory
Remove-Item -Path $TempDir -Recurse -Force

# Logging message
Write-Host "XDR Agent Cleaner has been run twice and system cleanup is complete."
