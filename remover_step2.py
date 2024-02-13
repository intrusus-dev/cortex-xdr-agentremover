# This part of the script is to be run after the system has been rebooted.

import os
import subprocess

# Re-run XDR Cleaner with admin rights
def run_xdr_cleaner_after_reboot(arguments):
    try:
        subprocess.run(['runas', '/user:Administrator', xdr_cleaner_exe] + arguments, check=True)
        print("XDR Cleaner has been run successfully for the second time.")
    except subprocess.CalledProcessError as e:
        print(f"Error re-running XDR Cleaner: {e}")

# Run XDR Cleaner for the second time
run_xdr_cleaner_after_reboot(['--silent', f'--log {log_path}'])

# Cleanup temporary directory if needed
# os.rmdir(temp_dir)  # Uncomment this line if you wish to remove the temporary directory after the process
