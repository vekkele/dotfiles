#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Update macOS
echo
echo "Looking for updates.. 💻"
echo
sudo softwareupdate -i -a

# Install Rosetta
echo
echo "Installing Rosetta 👨‍💻"
echo
sudo softwareupdate --install-rosetta --agree-to-license

# Install Homebrew
echo
echo "Installing Homebrew 🍺"
echo
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Immediately evaluate the Homebrew environment settings for the current session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Check installation and update
echo
echo "Checking installation.."
echo
brew update && brew doctor

# Install packages with Brewfile
echo
echo "Using Brewfile to install packages... 📦"
brew bundle
echo "Installation from Brewfile completed."

# Cleanup
echo
echo "Cleaning up... 🧹"
brew update && brew upgrade && brew cleanup && brew doctor

# Settings
echo
echo "Configuring default system settings... 💻"
source ./macos-settings.sh
echo "Done. Note that some of these changes require a logout/restart to take effect."

# Dotfiles
echo
echo "Setting up dotfiles... 👾"
stow -t ~ karabiner npm starship wezterm zsh

# Setup Git
echo
echo "Setting up Git "
echo

echo "Please enter your git username:"
read name
echo "Please enter your git email:"
read email

git config --global user.name "$name"
git config --global user.email "$email"
git config --global color.ui true

echo
echo "Git is ready!"

# Add ssh setup for github
echo
echo " Generating keys for github 🔑"
echo

mkdir -p ~/.ssh/github
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/github/id_ed25519
eval "$(ssh-agent -s)"

cat > ~/.ssh/config << EOL
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github/id_ed25519
EOL

pbcopy < ~/.ssh/github/id_ed25519.pub
echo
echo "Ssh key for github is copied to clipboard."
echo "Open https://github.com/settings/keys in browser and paste this key"
echo
echo "Press any key when you are done"
read

# Manual setup
echo
echo "Setup is finished 🎉"
echo "Follow these steps to manually setup the rest of the system:"
echo
echo "Apply rest of system settings"
echo "1. Setup control center"
echo
echo "2. Touch ID & Password -> Add fingers"
echo
echo "3. Keyboard"
echo "  Adjust keyboard brightness in low light -> disable"
echo "  Keyboard brightness -> low"
echo "  Turn keyboard backlight off after inactivity -> After 5 seconds"
echo "  Keyboard -> Keyboard shortcuts"
echo "    Spotlight -> Disable search (Replaced with Raycast)"
echo "    Modifier Keys -> Caps Lock -> No Action"
echo "  Keyboard -> Input Sources"
echo "    Add 'ABC' and 'Russian - PC'"
echo
echo "4. Internet Accounts -> login to google accounts"
echo
echo "Press any key to continue"
read

echo
echo "Manually setup some apps"
echo "  Setup toolbar with ICE"
echo "  Copy Raycast settings"
echo
echo "That's it! 🥳"