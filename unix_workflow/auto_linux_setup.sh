#!/bin/bash

# Function to ask yes/no questions
ask_yes_no() {
    while true; do
        read -p "$1 (yes/no) [default: yes]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) return 0;; # Default to yes if Enter is pressed
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Detect the operating system
OS=$(uname)

echo "Detected OS: $OS"

# Ask user if they want to customize the terminal
if ask_yes_no "Do you want to customize the terminal by installing ZSH, Oh My Zsh, and the Powerlevel10k theme?"; then
    # Check if the font "MesloLGS NF Regular.ttf" is installed
    if ask_yes_no "Is the font 'MesloLGS NF Regular.ttf' installed?"; then
        # Install zsh
        echo "Installing zsh..."
        apt install zsh

        # Check zsh version
        echo "Checking zsh version..."
        zsh --version

        # Restart the shell script
        echo "Restarting shell script..."
        source ~/.zshrc
        echo "Current shell: $SHELL"
        $SHELL --version

        # Install Oh My Zsh
        echo "Installing Oh My Zsh..."
        sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

        # Install plugins
        echo "Installing plugins..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

        # Install Powerlevel10k theme
        echo "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

        echo "Updating .zshrc configuration..."
        curl -sL "https://raw.githubusercontent.com/AmineDjeghri/Auto-Linux-Setup/main/.zshrc" > ~/.zshrc
        source ~/.zshrc
        # Print installation message
        echo -e "\e[93m(Optional) If you have custom configurations in your .bashrc, consider copying them to the .zshrc file.\e[0m"

    else
        echo "\033[0;33mPlease install the font 'MesloLGS NF Regular.ttf' before customizing the terminal."
        echo "You can check this link for instructions: https://github.com/AmineDjeghri/Auto-Linux-Setup/tree/main#1-setup-linux-automatically-\e[0m"
    fi
else
    echo "\e[93mTerminal customization skipped.\e[0m"
fi

# Ask user if they want to install Miniconda
if ask_yes_no "Do you want to install Miniconda3?"; then
    # Download and install Miniconda
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    source ~/.zshrc
    echo "initializing conda in ZSH'"
    cd ~
    ./miniconda3/bin/conda init zsh
    source ~/.zshrc

    # Display additional message
    echo "\e[93mRestart the Ubuntu terminal, you should see '(base)' at the left of any command."
    echo "Run 'conda env list' to check the installed environments and their paths.\e[0m"
fi

# install nvidia driver
if ask_yes_no "Do you want to install nvidia driver?"; then

  # Check if NVIDIA driver is installed
  if nvidia-smi &> /dev/null; then
    echo "NVIDIA driver is already installed."
    # Display GPU information
    echo "GPU Information:"
    nvidia-smi --query-gpu=name --format=csv,noheader
    nvidia-smi
  else
    # Check if running inside WSL
    if [ "$OS" == "Linux" ] && [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
        echo "Running inside Windows Subsystem for Linux (WSL). Please, install the NVIDIA driver on Windows."
    elif [ "$OS" == "Darwin" ]; then
        echo "No NVIDIA driver can be installed on macOS."
    elif [ "$OS" == "Linux" ]; then
      echo "Installing NVIDIA driver on Linux..."
        # Download the NVIDIA driver
        wget https://fr.download.nvidia.com/XFree86/Linux-x86_64/535.129.03/NVIDIA-Linux-x86_64-535.129.03.run

        # Make the downloaded file executable
        chmod +x NVIDIA-Linux-x86_64-535.129.03.run

        # Run the NVIDIA driver installer
        sudo ./NVIDIA-Linux-x86_64-535.129.03.run

        # Clean up the downloaded file (optional)
        rm NVIDIA-Linux-x86_64-535.129.03.run

        echo "NVIDIA driver installed successfully."

        # Display GPU information
        echo "GPU Information:"
        nvidia-smi --query-gpu=name --format=csv,noheader
        nvidia-smi
    else
    echo "Unsupported operating system: $OS"
    fi
  fi
fi