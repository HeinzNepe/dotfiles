#!/usr/bin/env bash


# The following code is "borrowed" and modified from https://github.com/theS1LV3R/dotfiles/

log_info "Thanks for installing my dotfiles! This is still a test, and note that THIS OVERWRITES YOUR CURRENT DOTFILES"
log_info "Press enter to continue or ctrl-c to abort"
read -r

log_info "Performing misc actions"


#==== Auto install different packages =====
#Check OS version
os_release=""
[[ -e /etc/debian_version ]] && os_release="debian"

#Define scripts
_install() {
  filename="install_$1.sh"

  # Common packages are installed automatically
  export common_packages="zsh neofetch curl wget net-tools python gum"
  export python_packages=""

  log_info "Running ./$filename"
  "./$filename"
}

# In the case that 
case "$os_release" in
debian) log_info "Detected Debian" && _install deb ;;
*) log_error "Unsupported distribution" && exit 1 ;;
esac

#===========================================


#==== Choose installs ====

# List the different options
CHANGE_SHELL="Change shell"
DOCKER_INSTALL="Install docker"

# Let the user see the options and choose
options="$(gum choose --no-limit --selected="All" "All" "$CHANGE_SHELL" "$DOCKER_INSTALL")"


# If selected, Change shell to zsh
if [[ $options == "All" ]] || [[ $options =~ ^$CHANGE_SHELL$ ]]; then
  log_verbose "$CHANGE_SHELL"

  log_info "Downlaoding font"

  gum spin -- ./../dot_local/share/fonts/download-fonts.sh

  zsh_bin=$(command -v zsh)

  # If the zsh isnt in the shells folder, it will add it
  if ! grep -qv "$zsh_bin" /etc/shells; then
    log_info "$zsh_bin not found in /etc/shells - enter password to add"
    echo "$zsh_bin" | sudo tee -a /etc/shells
  fi

  #Changes the shell of the user
  sudo chsh -s "$zsh_bin" "$USER"
fi

# If selected, Install docker
if [[ $options == "All"]] || [[ $options =~ ^$DOCKER_INSTALL$]]; then
  log_verbose "$DOCKER_INSTALL"

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

#========================
