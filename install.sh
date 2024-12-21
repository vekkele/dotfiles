#!/usr/bin/env bash

# COLOR
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Update macOS
echo
echo "${GREEN}Looking for updates.."
echo
sudo softwareupdate -i -a

echo
echo "${GREEN}Installing xcode-stuff 👨‍💻"
echo
xcode-select --install

# Install Rosetta
sudo softwareupdate --install-rosetta --agree-to-license

# Install Homebrew
echo
echo "${GREEN}Installing Homebrew"
echo
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Immediately evaluate the Homebrew environment settings for the current session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Check installation and update
echo
echo "${GREEN}Checking installation.."
echo
brew update && brew doctor

# Install packages with Brewfile
echo
echo "${GREEN}Using Brewfile to install packages..."
brew bundle
echo "${GREEN}Installation from Brewfile completed."

# Cleanup
echo
echo "${GREEN}Cleaning up..."
brew update && brew upgrade && brew cleanup && brew doctor

# Settings
echo
echo "${GREEN}Configuring default system settings..."
source ./macos-settings.sh
echo "${GREEN}Done. Note that some of these changes require a logout/restart to take effect."

# Dotfiles
echo
echo "${GREEN}Copying dotfiles..."
stow *

# Setup Git
echo
echo "${GREEN}Setting up Git"
echo

echo "${RED}Please enter your git username:${NC}"
read name
echo "${RED}Please enter your git email:${NC}"
read email

git config --global user.name "$name"
git config --global user.email "$email"
git config --global color.ui true

echo
echo "${GREEN}Git is ready!"

# Add ssh setup for github
echo
echo "${GREEN} Generating keys for github"
echo

mkdir -p ~/.ssh/github
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/github/id_ed25519
eval "$(ssh-agent -s)"

cat > ./test.txt << EOL
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github/id_ed25519
EOL

pbcopy < ~/.ssh/github/id_ed25519.pub
echo
echo "${RED}Ssh key for github is copied to clipboard."
echo "Open https://github.com/settings/keys in browser and paste this key"
echo
echo "${GREEN}Press any key when you are done"
echo

# Manual setup
echo
echo "${RED}Setup is finished"
echo "${GREEN}Follow these steps to manually setup the rest of the system:"
echo
echo "Apply rest of system settings${NC}"
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
echo "${GREEN}Press any key to continue"
read

echo
echo "${GREEN}Manually setup some apps${NC}"
echo "\tSetup toolbar with ${GREEN}ICE${NC}"
echo "\tCopy ${GREEN}Raycast${NC} settings"
echo
echo "${RED}That's it!"