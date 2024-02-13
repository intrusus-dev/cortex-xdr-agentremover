import os
import subprocess
import argparse

# Define the argument parser
parser = argparse.ArgumentParser(description='Automate the XDR Agent Cleaner process.')
parser.add_argument('--part', type=str, choices=['part1', 'part2'], required=True, help='Specify which part of the script to run: part1 before reboot, part2 after reboot.')

# Parse the command line arguments
args = parser.parse_args()

# Common variables
xdr_cleaner_exe = "C:\\path\\to\\XdrAgentCleaner.exe"
temp_dir = "C:\\temp\\XdrCleaner"
log_path = os.path.join(temp_dir, "CleanerLog.log")

# Ensure the temporary directory exists
if not os.path.exists(temp_dir):
    os.makedirs(temp_dir)

# Function to run XDR Cleaner
def run_xdr_cleaner():
    subprocess.call([xdr_cleaner_exe, '--silent', f'--log {log_path}'], shell=True)

if args.part == 'part1':
    # Part 1: Run XDR Cleaner for the first time
    print("Running XDR Agent Cleaner for the first time...")
    run_xdr_cleaner()
    print("Please reboot the machine to complete the cleaning process. After rebooting, run this script with --part2.")

elif args.part == 'part2':
    # Part 2: Run XDR Cleaner after the reboot
    print("Running XDR Agent Cleaner for the second time after reboot...")
    run_xdr_cleaner()
    print("XDR Agent Cleaner has been run successfully for the second time. The process is now complete.")

    # Optional: Cleanup temporary directory
    # os.remove(temp_dir)  # Uncomment this line if you wish to remove the temporary directory after the process
