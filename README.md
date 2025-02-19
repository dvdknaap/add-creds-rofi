# Credential Management and Script Automation Helper

This project provides a streamlined solution for managing credentials and generating reusable scripts for CTF challenges. With simple commands and automation, it ensures an efficient workflow while maintaining security and clarity.

---

## Features

- **Credential Management:** Easily store and retrieve IP addresses, usernames, and passwords.
- **Script Automation:** Automatically create scripts (e.g., for Gobuster, nmap, etc.) for each CTF challenge.
- **Customizable Directories:** Keep all generated scripts and credentials organized by CTF name.
- **Environment Variable Setup:** Automatically load CTF-related credentials as environment variables for easier access during challenges.

---

## Installation

### Automated Installation

You can quickly set up the project using the included `install.sh` script:

1. Clone this repository and navigate to it:
   ```bash
   git clone https://github.com/dvdknaap/add-creds-rofi.git ~/.addCreds
   cd ~/.addCreds
   ```

2. Run the `install.sh` script:
   ```bash
   bash install.sh
   ```

This script will:
- Install dependencies (like `rofi`).
- Clone the `rofi-hacking-helper` repository.
- Set up a keyboard shortcut (e.g., `Ctrl+Shift+M`) to quickly access scripts.
- Add the `addCreds` alias to your shell configuration file (`.bashrc` or `.zshrc`).

3. Reload your shell configuration to apply changes:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

### Manual Installation

If you prefer manual setup, follow these steps:

1. Clone this repository:
   ```bash
   git clone git@github.com:dvdknaap/add-creds-rofi.git ~/.addCreds
   cd ~/.addCreds
   ```

2. Add the helper script to your `~/.zshrc` or `~/.bashrc` file to enable functionality:
   ```bash
   ln -sf /home/kali/.addCreds/.addCreds_aliases ~/.addCreds_aliases

   if [ -f ~/.addCreds_aliases  ]; then
       . ~/.addCreds_aliases
   fi
   ```

3. Reload your shell:
   ```bash
   source ~/.zshrc   # or ~/.bashrc
   ```

4. Clone the `rofi-hacking-helper` repository to your Desktop:
   ```bash
   git clone git@github.com:spipm/rofi-hacking-helper.git ~/Desktop/base
   ```

5. Set up a keyboard shortcut (e.g., `Ctrl+Shift+M`) in your desktop environment to launch the `rofisearch_scripts_menu.sh` script:
   ```bash
   /home/<username>/Desktop/base/code/xdotool/rofisearch_scripts_menu.sh
   ```

---

## Usage

### Adding Credentials
1. Use the `addCreds` script to add new credentials:
   ```bash
   addCreds
   ```
2. Follow the prompts to enter:
   - CTF Name (Credential Name)
   - IP Address
   - Username
   - Password

### Example Output
Once completed, the tool:
- Creates a directory for the credentials and scripts.
- Stores the credentials in `${HOME}/.ctf_creds/<ctf_name>`.
- Generates reusable scripts (e.g., `get_ip.sh`, `do_gobuster_dir.sh`) in `~/Desktop/base/code/xdotool/scripts/<ctf_name>`.

### Generating Custom Scripts
Use the `create_script` function to add your custom scripts:
```bash
create_script "<ctf_name>" "<script_name>" "<script_content>"
```
Example:
```bash
create_script "example_ctf" "run_nmap" "nmap -sC -sV -oN example_scan.txt $example_ctf_ip"
```
This creates a script `run_nmap.sh` in the appropriate CTF script directory.

### Accessing Scripts
Navigate to the generated scripts for a CTF:
- Press `Ctrl+Shift+M` (if configured).
- Use the menu to browse to the desired CTF folder.

---

## Uninstalling
To remove the tool, delete the main directory and remove the `source` line from your shell configuration file:
```bash
rm -rf ~/.addCreds
sed -i '/addCreds/d' ~/.zshrc  # or ~/.bashrc
```
Reload your shell:
```bash
source ~/.zshrc   # or ~/.bashrc
```


