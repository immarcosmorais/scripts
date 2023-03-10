#!/bin/bash

# inspired by
# https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

if ! command -v brew; then
    echo "Instalando homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >>~/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
fi

echo "find CLI tools update"
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true

if [[ ! -z "$PROD" ]]; then
    softwareupdate -i "$PROD" --verbose
fi

_packages=(
    # Linguagens
    pypy python
    # Desenvolvimento
    nvm git gradle maven
    # Outros
    btop htop transmission-cli
)

_cask_apps=(
    # Linguages
    oracle-jdk-javadoc oracle-jdk
    #Ides
    visual-studio-code intellij-idea-ce pycharm-ce jetbrains-toolbox postman
    # Desenvolvimento
    android-file-transfer gitahead docker android-platform-tools
    # Reunioes
    zoom skype
    # Mensagens
    whatsapp telegram
    # Outros
    adguard clickup google-drive miro transmission vlc discord hot notion
    rectangle tunnelblick wpsoffice utm cakebrew maccy spotify
)

IFS=$'\n' _apps_sorted=($(sort <<<"${_packages[*]}"))
unset IFS

echo "Instalando pacotes..."
brew install ${_apps_sorted[@]}

IFS=$'\n' _apps_sorted=($(sort <<<"${_cask_apps[*]}"))
unset IFS

echo "Instalando apps casks..."
brew install --cask ${_apps_sorted[@]}

sudo pip3 install --upgrade pip
sudo pip3 install --upgrade setuptools

git config --global user.email "marcosmorais.contact@gmail.com"
git config --global user.name "Marcos Morais"

brew update
brew upgrade
brew cleanup
brew doctor
brew autoupdate start
