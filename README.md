# Cortex XDR Agent Cleaner Automation Scripts

![Cortex XDR Logo](https://media.licdn.com/dms/image/D5612AQE3_mg6EduwdQ/article-cover_image-shrink_600_2000/0/1661990539721?e=2147483647&v=beta&t=L8kvj_IDOC1MmGQ3BpbMQYkuT-GxaCxPjowWLCHIlgQ)

This repository contains an automation script for to remove the Palo Alto Networks Cortex XDR Agent. The script is designed to automate the process of uninstalling the Cortex XDR agent from endpoints where the agent cannot be upgraded or uninstalled through the usual methods due to installation issues. These scripts provide a solution for IT administrators and cybersecurity professionals to efficiently address common issues with Cortex XDR agent installations.

## :page_with_curl: About the Script

This repository includes a PowerShell script tailored for Windows environments. The script automates the process of attempting to uninstall the Cortex XDR agent using the standard uninstaller and, if needed, falling back to the Cortex XDR Agent Cleaner tool. The script also schedules a task to run the XDR Agent Cleaner tool after a system reboot, and deletes the scheduled task afterwards.

### Features

- **Automated Tamper Protection Disablement**: Automatically handles the disabling of tamper protection using the Cortex utility tool.
- **Fallback to Cortex Cleaner Tool**: If the standard uninstallation fails, the script automatically invokes the Cortex Cleaner Tool with appropriate parameters.
- **Scheduled Task for Reboot**: Automatically schedules the cleaner tool to run after a reboot if the initial uninstall attempt fails.
- **Logging**: Detailed logging of all operations to help diagnose and troubleshoot.

## 🛠️ How to Use

### Prerequisites

- **Environment**: Windows with PowerShell 5.1 or later.
- **Administrative Rights**: The script must be run with administrative privileges.

### Execution Steps

1. **Download the Script**
   - Download `cortex_remover.ps1` to the target endpoint.

2. **Prepare Execution Environment**
   - Ensure that the paths to the MSI installer and the Cortex Cleaner Tool are accessible and properly shared if located on a network drive.

3. **Run the Script**
   - Open PowerShell as an Administrator.
   - Navigate to the directory containing the script.
   - Execute the script with the required parameters:
     ```powershell
     .\cortex_remover.ps1 -msiPath "\\path\to\CortexAgent.msi" -cleanerPath "\\path\to\XdrAgentCleaner.exe" -uninstallPw "YourPassword"
     ```
   - Follow any on-screen prompts, which may include manual interventions such as confirming operations or handling unexpected errors.

### Script Parameters

- **`-msiPath`**: The full network or local path to the Cortex XDR MSI installer.
- **`-cleanerPath`**: The full network or local path to the Cortex XDR Agent Cleaner executable.
- **`-uninstallPw`**: The uninstallation password required for removing the Cortex XDR agent or disabling its tamper protection.

## 🖥️ Using with SCCM

If you are using SCCM (System Center Configuration Manager) to deploy this script, follow these steps:

1. **Package Creation**:
   - Create a new package in SCCM and include the `cortex_remover.ps1` script, the MSI installer, and the XDR Agent Cleaner tool in the package source.

2. **Program Creation**:
   - Create a new program in the package with the following command line:
     ```powershell
     powershell.exe -ExecutionPolicy Bypass -File cortex_remover.ps1 -msiPath "\\network\path\to\CortexAgent.msi" -cleanerPath "\\network\path\to\XdrAgentCleaner.exe" -uninstallPw "YourPassword"
     ```
   - Ensure that the program is set to run with administrative rights.

3. **Deploy the Package**:
   - Deploy the package to the target collection. Make sure to configure the deployment settings to allow the script to run with administrative rights.

### Monitoring and Logging

- The script generates logs in the `C:\Temp\Cortex\` directory. Check these logs to monitor the progress and troubleshoot any issues that may arise during the uninstallation process.

## ❓ Support

For issues, questions, or contributions regarding the scripts, please open an issue or submit a pull request to this repository. For detailed usage of each script and its functions, refer to the inline comments within the script itself.

### External Resources

- For more comprehensive guidance on the Cortex XDR Agent Cleaner tool and other operational procedures, refer to the [official Palo Alto Networks knowledge base article](https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA14u000000oNFiCAM).

## ⚠️ Disclaimer

This script has been tested only in my own environment and is provided as-is without any guarantees or warranty. It is an independent project and is not officially supported by Palo Alto Networks. 

By using this script, you acknowledge and agree that the author is not responsible for any direct or indirect damage or loss caused by the use or misuse of this script. Use it at your own risk. Ensure that you test this script in a controlled environment before deploying it in a production environment.

Thank you for using or contributing to this project. Your feedback and contributions are highly valued and play a significant role in improving the effectiveness of these tools.
