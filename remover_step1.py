import os
import subprocess
import sys

# Define paths
xdr_cleaner_exe = "C:\\path\\to\\XdrAgentCleaner.exe"
temp_dir = "C:\\temp\\XdrCleaner"
log_path = os.path.join(temp_dir, "CleanerLog.log")

# Ensure the temporary directory exists
if not os.path.exists(temp_dir):
    os.makedirs(temp_dir)

# Function to run XDR Cleaner with admin rights
def run_xdr_cleaner(arguments):
    try:
        subprocess.run(['runas', '/user:Administrator', xdr_cleaner_exe] + arguments, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running XDR Cleaner: {e}")
        sys.exit(1)

# Run XDR Cleaner for the first time
run_xdr_cleaner(['--silent', f'--log {log_path}'])

# After running, you should manually reboot the machine
print("Please reboot the machine to complete the cleaning process. After rebooting, run the second part of this script.")
