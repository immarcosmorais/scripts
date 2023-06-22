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
    python
    # Desenvolvimento
    git gradle maven nvm yarn
    # Outros
    htop scrcpy
)

_cask_apps=(
    # Linguages
    oracle-jdk-javadoc oracle-jdk
    #Ides
    visual-studio-code intellij-idea-ce postman
    # Desenvolvimento
    android-file-transfer gitahead docker android-platform-tools dbeaver-community github mongodb-compass jupyterlab anaconda
    # Reunioes
    zoom skype
    # Mensagens
    # whatsapp telegram
    # Outros
    adguard clickup google-drive transmission vlc hot notion rectangle tunnelblick wpsoffice utm maccy spotify logi-options-plus
)

IFS=$'\n' _apps_sorted=($(sort <<<"${_packages[*]}"))
unset IFS

echo "Instalando pacotes..."
brew install ${_apps_sorted[@]}

IFS=$'\n' _apps_sorted=($(sort <<<"${_cask_apps[*]}"))
unset IFS

echo "Instalando apps casks..."
brew install --cask ${_apps_sorted[@]}

# Configurando Python
echo "alias python=/opt/homebrew/bin/python3" >>~/.zshrc
echo "alias pip=/opt/homebrew/bin/pip3" >>~/.zshrc

sudo pip3 install --upgrade pip
sudo pip3 install --upgrade setuptools

# Configurando NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

mkdir ~/.nvm
nvm install --lts
nvm use --lts

# Configurando Git
git config --global user.email "marcosmorais.contact@gmail.com"
git config --global user.name "Marcos Morais"

# Configurando brew
brew update
brew upgrade
brew cleanup
brew doctor
brew autoupdate start
