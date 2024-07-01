# Cortex XDR Agent Cleaner Automation Scripts

![Cortex XDR Logo](https://media.licdn.com/dms/image/D5612AQE3_mg6EduwdQ/article-cover_image-shrink_600_2000/0/1661990539721?e=2147483647&v=beta&t=L8kvj_IDOC1MmGQ3BpbMQYkuT-GxaCxPjowWLCHIlgQ)

This repository contains automation scripts for the Palo Alto Networks Cortex XDR Agent Cleaner tool. The scripts are designed to automate the process of uninstalling the Cortex XDR agent from endpoints where the agent cannot be upgraded or uninstalled through the usual methods due to installation issues. These scripts provide a solution for IT administrators and cybersecurity professionals to efficiently address common issues with Cortex XDR agent installations.

## :page_with_curl: About the Script

This repository includes a PowerShell script tailored for Windows environments. The script automates the process of attempting to uninstall the Cortex XDR agent using the standard uninstaller and, if needed, falling back to the Cortex XDR Agent Cleaner tool.

### Features

- **Automated Tamper Protection Disablement**: Automatically handles the disabling of tamper protection using the Cortex utility tool.
- **Fallback to Cortex Cleaner Tool**: If the standard uninstallation fails, the script automatically invokes the Cortex Cleaner Tool with appropriate parameters.
- **Logging**: Detailed logging of all operations to help diagnose and troubleshoot.

## :wrench: How to Use

### Prerequisites

- **Environment**: Windows with PowerShell 5.1 or later.
- **Cortex XDR Agent Cleaner Tool**: Get it from Palo Alto Networks Support.
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

4. **Clean up the Cortex XDR Console**
   - If the sensor still appears in the console, delete it manually from the inventory.
  
#### Script Parameters

- **`-msiPath`**: The full network or local path to the Cortex XDR MSI installer.
- **`-cleanerPath`**: The full network or local path to the Cortex XDR Agent Cleaner executable.
- **`-uninstallPw`**: The uninstallation password required for removing the Cortex XDR agent or disabling its tamper protection.

## ❓ Support

For issues, questions, or contributions, please open an issue or pull request in this repository. For more detailed guidance on the Cortex XDR Agent Cleaner tool, refer to the [official Palo Alto Networks knowledge base article](https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA14u000000oNFiCAM).


## ⚠️ Disclaimer

This script has been tested only in my own environment and is provided as-is without any guarantees or warranty. It is an independent project and is not officially supported by Palo Alto Networks. 

By using this script, you acknowledge and agree that the author is not responsible for any direct or indirect damage or loss caused by the use or misuse of this script. Use it at your own risk. Ensure that you test this script in a controlled environment before deploying it in a production environment.

Thank you for using or contributing to this project. Your feedback and contributions are highly valued and play a significant role in improving the effectiveness of these tools.
