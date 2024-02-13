# Cortex XDR Agent Cleaner Automation Scripts

![Cortex XDR Logo](https://media.licdn.com/dms/image/D5612AQE3_mg6EduwdQ/article-cover_image-shrink_600_2000/0/1661990539721?e=2147483647&v=beta&t=L8kvj_IDOC1MmGQ3BpbMQYkuT-GxaCxPjowWLCHIlgQ)

This repository contains automation scripts for the Palo Alto Networks Cortex XDR Agent Cleaner tool. The scripts are designed to automate the process of uninstalling the Cortex XDR agent from endpoints where the agent cannot be upgraded or uninstalled through the usual methods due to installation issues. These scripts provide a solution for IT administrators and cybersecurity professionals to efficiently address common issues with Cortex XDR agent installations.

## :page_with_curl: About the Scripts

The repository includes two sets of scripts:

### :gear: PowerShell Script

The PowerShell script is tailored for Windows environments. It automates the process of running the XDR Agent Cleaner tool twice with a system reboot in between, as recommended for complete uninstallation of the Cortex XDR agent.

- **[Run-CortexCleaner.ps1](/PowerShell/Run-CortexCleaner.ps1):** Automates the uninstallation process, including extraction of the Cleaner tool, execution, reboot, and cleanup.

### :snake: Python Script

The Python script offers a cross-platform alternative for environments where Python is preferred or more suitable. Similar to the PowerShell script, it facilitates the running of the XDR Agent Cleaner tool, handling the necessary operations before and after a system reboot.

- **[run_cortex_cleaner.py](/Python/run_cortex_cleaner.py):** Split into two parts to accommodate the reboot requirement, this script automates the Cleaner tool execution process with logging and error handling.

## :wrench: How to Use

### Prerequisites

- **PowerShell Script:** Windows environment with PowerShell 5.1 or later.
- **Python Script:** Python 3.6 or later installed on the target system.

### Execution Steps

#### PowerShell

1. Download `Run-CortexCleaner.ps1` to the target endpoint.
2. Open PowerShell as an Administrator.
3. Navigate to the directory containing the script.
4. Execute the script: `.\Run-CortexCleaner.ps1`
5. Follow the on-screen instructions for rebooting and completing the process.

#### Python

1. Download `run_cortex_cleaner.py` (both parts) to the target endpoint.
2. Open a command prompt or terminal as an Administrator.
3. Run the first part of the script: `python run_cortex_cleaner.py --part1`
4. After rebooting, run the second part: `python run_cortex_cleaner.py --part2`

## :question: Support

For issues, questions, or contributions, please open an issue or pull request in this repository. For more detailed guidance on the Cortex XDR Agent Cleaner tool, refer to the [official Palo Alto Networks knowledge base article](https://knowledgebase.paloaltonetworks.com/KCSArticleDetail?id=kA14u000000oNFiCAM).
