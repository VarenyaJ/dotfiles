#!/usr/bin/env bash
#incorporates DTOS script (https://gitlab.com/dtos/dtos/-/blob/master/dtos)

###Basic Warnings
    echo "## Syncing the repos and installing 'dialog' if not installed ##"
    #
    cd && sudo pacman --noconfirm --needed -Syu dialog || error "Error syncing the repos."
    #
    welcome || error "User choose to exit."
    #
    speedwarning() { \
        dialog --colors --title "\Z7\ZbInstalling DTOS!" --yes-label "Continue" --no-label "Exit" --yesno  "\Z4WARNING! The ParallelDownloads option is not enabled in /etc/pacman.conf. This may result in slower installation speeds. Are you sure you want to continue?" 16 60 || error "User choose to exit."
    }
    #
    distrowarning() { \
        dialog --colors --title "\Z7\ZbInstalling DTOS!" --yes-label "Continue" --no-label "Exit" --yesno  "\Z4WARNING! While this script works on all Arch based distros, some distros choose to package certain things that we also package, please look at the package list and remove conflicts manually. Are you sure you want to continue?" 16 60 || error "User choose to exit."
    }
    #
    grep -qs "#ParallelDownloads" /etc/pacman.conf && speedwarning
    grep -qs "ID=arch" /etc/os-release || distrowarning
    #
    localewarning() { \
            [[ -z $LANG || -z $LC_CTYPE ]] && \
            dialog --colors --title "\Z7\ZbInstalling DTOS!" --msgbox "\Z4WARNING! Your locales have not been set! Please check that both the LANG and LC_CTYPE variables are set to the appropriate locale in /etc/locale.conf (NOTE: they should both be the same). Run 'sudo locale-gen', reboot and run the script again. You can reference the Arch Wiki while doing so: https://wiki.archlinux.org/title/locale" 16 60 && error "Your locales have not been set! Please check that both the LANG and LC_CTYPE variables are set to the appropriate locale in /etc/locale.conf (NOTE: they should both be the same). Run 'sudo locale-gen', reboot and run the script again. You can reference the Arch Wiki while doing so: https://wiki.archlinux.org/title/locale"
    }
    #
    localewarning
    #
    lastchance() { \
        dialog --colors --title "\Z7\ZbInstalling DTOS!" --msgbox "\Z4WARNING! The DTOS installation script is currently in public beta testing. There are almost certainly errors in it; therefore, it is strongly recommended that you not install this on production machines. It is recommended that you try this out in either a virtual machine or on a test machine." 16 60

        dialog --colors --title "\Z7\ZbAre You Sure You Want To Do This?" --yes-label "Begin Installation" --no-label "Exit" --yesno "\Z4Shall we begin installing DTOS?" 8 60 || { clear; exit 1; }
    }
    #
    lastchance || error "User choose to exit."
#
###Make sure XFCE and Cinnamon are installed as fallbacks:
    sudo pacman -Syyu
    #Install XFCE and Cinnamon
    #https://discovery.endeavouros.com/desktop-environments/how-to-install-desktop-environments-next-to-your-existing-ones/2021/03/
    sudo pacman -Syu xfce4 xfce4-goodies && sudo pacman -Syu cinnamon system-config-printer gnome-keyring blueberry cinnamon-translations
    sudo pacman -Syu && sudo pacman -S git && git --version
    sudo pacman -Sy vim flameshot neovim emacs neofetch htop lolcat firefox
    sudo pacman -S emacs git ripgrep fd
    #cd && git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    #.emacs.d/bin/doom install
    #emacs
    #https://obsproject.com/wiki/install-instructions#unofficial-builds
    #https://obsproject.com/wiki/unofficial-linux-builds#arch-linuxmanjaro
    sudo pacman -S gimp vlc libreoffice-still obs-studio
    sudo pacman -S base-devel
    #Install Awemsome
    #Window Managers
        #https://epsi-rns.github.io/desktop/2020/10/11/slides-desktop-customization.html
        #https://github.com/epsi-rns/berkas2/tree/master/impress-presentation
    #Awesome
        #https://youtu.be/qKtit_B7Keo
        #https://epsi-rns.github.io/desktop/2019/06/15/awesome-overview.html
        https://youtu.be/eUV94f_uMFI
    #bspwn
        #https://youtu.be/VKSxDWLLfn4
    #Comprehensive Guide
        #https://youtu.be/Obzf9ppODJU
    #Top 8?
        #https://youtu.be/wGXdqZv71CA
#
###Time for a Window Manager
    echo "##################################################"
    echo "##        CHOOSE YOUR WINDOW MANAGER(S)         ##"
    echo "##    Choices are: xmonad, awesome, & qtile.    ##"
    echo "##  You should choose at least one, otherwise,  ##"
    echo "##  you will not have a graphical environment.  ##"
    echo "## If unsure, Xmonad is the recommended choice. ##"
    echo "##################################################"

    while true; do
        read -p "Do you wish to install XMonad? (Yy/Nn)" yn
        case $yn in
            [Yy]* ) sudo pacman -Sy xmonad xmonad-contrib xmobar dtos-xmonad dtos-xmobar;
                    break;;
            [Nn]* ) echo "You choose not to install XMonad.";
                    break;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    while true; do
    read -p "Do you wish to install Awesome? (Yy/Nn)" yn
        case $yn in
            [Yy]* ) sudo pacman -Sy awesome dtos-awesome ;
                    break;;
            [Nn]* ) echo "You choose not to install Awesome.";
                    break;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    while true; do
        read -p "Do you wish to install Qtile? (Yy/Nn)" yn
        case $yn in
            [Yy]* ) sudo pacman -Sy qtile dtos-qtile ;
                    break;;
            [Nn]* ) echo "You choose not to install Qtile." ;
                    break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
#
###Extra Managers/Packages
    cd
    #install yay
        #https://github.com/Jguer/yay
        pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
        #yay -Ss <package-name>
        #yay -S <package-name>
    cd
    #install aura
        #https://github.com/fosskers/aura#installation
        #https://youtu.be/xPRJWHghWM8?list=PL5--8gKSku16Ncr9H_BAZSzWecjaSWlvY
        git clone https://aur.archlinux.org/aura-bin.git
        cd aura-bin && makepkg -si && cd
        #sudo pacman -U <the-package-file-that-makepkg-produces>
    cd
#
###Firewall + SSH
    cd
    #install firewall
        #https://ostechnix.com/how-to-setup-firewall-with-gufw-on-linux-desktop/
        sudo pacman -Sy ufw && sudo systemctl enable ufw --now && systemctl status ufw && sudo ufw enable && sudo pacman -S gufw
        #https://www.linuxcapable.com/how-to-install-configure-ufw-firewall-on-arch-linux/
        #sudo ufw disable
        #remove firewall: sudo pacman -R ufw
            echo "https://man.archlinux.org/man/community/gufw/gufw.8.en"
            echo "https://itsfoss.com/set-up-firewall-gufw/"
    cd
    #Install ssh
        #https://linuxhint.com/install_ssh_server_on_arch_linux/
        sudo pacman -Syu && sudo pacman -S openssh -y && sudo systemctl status sshd && sudo systemctl start sshd && sudo systemctl status sshd && sudo systemctl stop sshd && sudo systemctl enable sshd && sudo systemctl disable sshd && sudo ufw allow ssh
        #ip a
        #ssh USERNAME@IP_ADDRESS
        #ls /etc/ssh/sshd_config
        #man sshd_config
        #sudo nano /etc/ssh/sshd_config
        #sudo systemctl restart sshd
        #ssh -p 22 USERNAME@IP_ADDRESS
        #https://distro.tube/kb/ssh.html
            #Create key pair on client machine: ssh-keygen -t ed25519
            #Enter file in which to save the key (home/sammy.ssh/id_ed25519): Go with default name or change it if you wish.
            #Enter passphrase (empty for no passphrase): Up to you to do this or not, but it’s strongly recommended.
        #Copy public key to server: ssh-copy-id sammy@your_server_address You can copy the public key into the server’s authorized_keys file with the ssh-copy-id command. Once the command completes, you will be able to log into the server via SSH without being prompted for a password. However, if you set a passphrase when creating your SSH key, you will be asked to enter the passphrase at that time. This is your local ssh client asking you to decrypt the private key, it is not the remote server asking for a password.
        #Disabling root login
            #sudo vim /etc/ssh/sshd_config
            #PermitRootLogin no
            #AllowUsers derek (or whatever user name)
        #Disabling password SSH authentication
            #sudo vim /etc/ssh/sshd_config
            #PasswordAuthentication no (also make sure line isn’t commented with a #)
            #sudo systemctl reload sshd (to put config changes into effect)
        #Disabling root login
            #sudo vim /etc/ssh/sshd_config
            #PermitRootLogin no
            #AllowUsers derek (or whatever user name)
        #
    #
#
###Show some Power and Config Files:
    #https://linoxide.com/tlp-make-linux-laptop-battery-last-longer/
    sudo pacman -Syyu && sudo pacman -Syu && sudo pacman -S tlp tlp-rdw && systemctl start tlp.service && systemctl enable tlp.service && sudo tlp-stat -s && sudo tlp-stat
        echo "https://linuxcommandlibrary.com/man/tlp-stat.html"
    cat /etc/tlp.conf
        echo "System-wide user configuration file, uncomment parameters here to override default settings and customization files below."
    cat /etc/tlp.d/*.conf*
        echo "System-wide drop-in customization files, overriding defaults below."
    cat /usr/share/tlp/defaults.conf
        echo "Intrinsic default settings. DO NOT EDIT this file, instead use one of the above alternatives."
    cat /run/tlp/run.conf
        echo "Effective settings consolidated from all above files. DO NOT CHANGE this file, it is for reference only and regenerated on every invocation of TLP."
    cat /etc/default/tlp
        echo "Obsolete system-wide configuration file. DO NOT USE this file, it is evaluated only when /etc/tlp.conf is non-existent."
    #systemctl mask systemd-rfkill.service && systemctl mask systemd-rfkill.socket
        echo "https://docs.kernel.org/driver-api/rfkill.html"
        echo "https://linuxconfig.org/how-to-manage-wifi-interfaces-with-rfkill-command-on-linux"
    systemctl status fstrim.timer && systemctl enable fstrim.timer
        echo "https://opensource.com/article/20/2/trim-solid-state-storage-linux"
    systemctl status bluetooth.service
        echo "https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units"
        echo "https://www.linode.com/docs/guides/introduction-to-systemctl/"
    sudo pacman -S mkinitcpio-git -M && mkinitcpio -M
        echo "https://wiki.archlinux.org/title/Mkinitcpio"
        echo "https://man.archlinux.org/man/mkinitcpio.8"
        echo "https://wiki.archlinux.org/title/Mkinitcpio/Minimal_initramfs"
        echo "https://man.archlinux.org/man/mkinitcpio.conf.5"
    sudo pacman -Sy grub-customizer
        echo "https://itsfoss.com/customize-grub-linux/"
#
cd && sudo pacman update -Syyu
#
###Disable potential "beeping" noise with every input:
    sudo echo "xset -b" >> ~/.xprofile
#
###Antivirus:
    #https://docs.clamav.net/manual/Installing.html
    #https://www.linuxcapable.com/how-to-install-clamav-on-arch-linux/
    sudo pacman -Sy clamav && sudo systemctl stop clamav-freshclam && sudo freshclam && sudo systemctl enable clamav-freshclam --now
    #In the future, if you need to disable clamav-freshclam, the following command will do the trick: sudo systemctl disable clamav-freshclam --now
    systemctl status clamav-freshclam
    ls -l /var/lib/clamav/

    #First update database:
    sudo freshclam
    #You may get a notification that clamd was not notified. This is normal because we haven't started the service yet. 
    #Start and enable service: 
    sudo systemctl enable --now clamav-daemon
    sudo systemctl enable --now clamav-freshclam
    #Check status daemons:
    sudo systemctl status clamav-daemon && sudo systemctl status clamav-freshclam
    #Check database version:
    freshclam -V
    #https://www.ghacks.net/2017/05/02/how-to-install-clamav-with-clamtk-ui-in-gnulinux/
    #ClamTK is available in the repos, you can install it with pacman:
    sudo pacman -S clamtk


#
###Install Unzip
    #https://www.cyberciti.biz/faq/how-to-unzip-a-zip-file-using-the-linux-and-unix-bash-shell-terminal/
    pacman -S unzip
    #tar -xvf {file.zip} -C /dest/directory/
#
###Install Rust
        #https://www.makeuseof.com/getting-started-with-pacman-commands/
        #https://bbs.archlinux.org/viewtopic.php?id=138155
        #https://bbs.archlinux.org/viewtopic.php?id=42352
        #https://unix.stackexchange.com/questions/354291/how-to-set-environment-variables-at-startup-in-archlinux
        #https://www.rust-lang.org/tools/install
        #https://rustup.rs/
        #https://rust-lang.github.io/rustup/installation/index.html
        #https://linuxh2o.com/how-to-install-latest-rust-on-linux/
        #Rust
        #https://wiki.archlinux.org/title/Rust#Installation
        #https://www.rust-lang.org/tools/install
        #https://www.rust-lang.org/tools/install
    sudo pacman -S curl cmake
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    source $HOME/.bashrc  // This is only for bash shell users 
    source $HOME/.profile
    rustc --version
#
###Install Alacritty
    #https://youtu.be/PZPMvTvUf1Y
    #https://github.com/alacritty/alacritty/blob/master/docs/features.md
    #https://alacritty.org/
    #cargo install alacritty
    #https://github.com/alacritty/alacritty/blob/master/INSTALL.md
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    rustup override set stable
    rustup update stable
    sudo pacman -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python
    cargo build --release
    #test with:
    infocmp alacritty
    #if doesn't work, use:
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
    
    #either
        echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc
    #or:
        mkdir -p ~/.bash_completion
        cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
        echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
    #
#
###Install Findex
        #git clone https://github.com/mdgaziur/findex
        #./installer.sh
    sudo pacman -S findex-git
    systemctl --user enable findex.service
    systemctl --user enable findex-restarter.path

#
###Install Pfetch
    wget https://github.com/dylanaraps/pfetch/archive/master.zip
    unzip master.zip
    sudo install pfetch-master/pfetch /usr/local/bin/
    ls -l /usr/local/bin/pfetch
    pfetch
#
###Install Fonts
    #https://linuxconfig.org/how-to-install-and-manage-fonts-on-linux
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/FiraMono.zip
    #https://github.com/ryanoasis/nerd-fonts#font-installation
    git clone https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts
    ./install.sh Fira Code Nerd Font
    ./install.sh Fira Code
    # curl -fLo "<FONT NAME> Nerd Font Complete.otf" \
    #https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/<FONT_PATH>/complete/<FONT_NAME>%20Nerd%20Font%20Complete.otf
    fc-cache -v
#
###Install Starship Prompt
        #https://youtu.be/LDLisRPAC_g
        #https://starship.rs/config/
        #https://starship.rs/presets/
        #https://fishshell.com/
    #https://starship.rs/
    curl -sS https://starship.rs/install.sh | sh
    vim ~/.bashrc
    #eval "$(starship init bash)"
#
###Install Miscellaneous
    cd
    #Wordlet
        cargo install wordlet
        #wordlet @ https://github.com/scottluptowski/wordlet
        #   -difficulty
        #   --theme
    #
    yay -S brave-bin
    #https://vscodium.com/#install
    yay -S vscodium-bin
    #https://github.com/balena-io/etcher
    yay -S balena-etcher
    #yay -R balena-etcher
    
    #https://github.com/flightlessmango/MangoHud
    git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
    cd MangoHud
    ./build.sh build
    cd
#
###Exa:
    #https://itsfoss.com/exa/
    #https://github.com/ogham/exa#command-line-options
    #https://the.exa.website/features/colours
    sudo pacman -S exa
    exa -lh
    exa --git -lh
    exa -abghHliS
    exa --help
#
cd && sudo pacman -Syu && neofetch | lolcat
#https://www.linode.com/docs/guides/introduction-to-systemctl/
#https://linuxize.com/post/linux-shutdown-command/
#sudo shutdown -r now
#sudo systemctl reboot
#
cd && sudo pacman update -Syyu
continue_warning() { \
        dialog --colors --title "\Z7\ZbMoving on to DTOS" --yes-label "Continue" --no-label "Exit" --yesno  "\Z4WARNING! While this script works on all Arch based distros, some distros choose to package certain things that we also package, please look at the package list and remove conflicts manually. Are you sure you want to continue?" 16 60 || error "User choose to exit."
    }
continue_warning()
#
###Adding DTOS Repos
    addrepo() { \
        echo "#########################################################"
        echo "## Adding the DTOS core repository to /etc/pacman.conf ##"
        echo "#########################################################"
        grep -qxF "[dtos-core-repo]" /etc/pacman.conf ||
            ( echo " "; echo "[dtos-core-repo]"; echo "SigLevel = Required DatabaseOptional"; \
            echo "Server = https://gitlab.com/dtos/\$repo/-/raw/main/\$arch") | sudo tee -a /etc/pacman.conf
    }
    #
    addrepo || error "Error adding DTOS repo to /etc/pacman.conf."
    #
    addkeyserver() { \
        echo "#######################################################"
        echo "## Adding keyservers to /etc/pacman.d/gnupg/gpg.conf ##"
        echo "#######################################################"
        grep -qxF "keyserver.ubuntu.com:80" /etc/pacman.d/gnupg/gpg.conf || echo "keyserver hkp://keyserver.ubuntu.com:80" | sudo tee -a /etc/pacman.d/gnupg/gpg.conf
        grep -qxF "keyserver.ubuntu.com:443" /etc/pacman.d/gnupg/gpg.conf || echo "keyserver hkps://keyserver.ubuntu.com:443" | sudo tee -a /etc/pacman.d/gnupg/gpg.conf
    }
    #
    addkeyserver || error "Error adding keyservers to /etc/pacman.d/gnupg/gpg.conf"
    #
    receive_key() { \
        local _pgpkey="A62D56CABD8DD76E"
        echo "#####################################"
        echo "## Adding PGP key $_pgpkey ##"
        echo "#####################################"
        sudo pacman-key --recv-key $_pgpkey
        sudo pacman-key --lsign-key $_pgpkey
    }
    #
    receive_key || error "Error receiving PGP key $_pgpkey"

#
###Install each package listed in DT's pkglist.txt file
    git clone https://gitlab.com/dtos/dtos
    cd dtos/
    sudo pacman --needed --ask 4 -Sy - < pkglist.txt || error "Failed to install required packages."
#
###Snap:
    #https://snapcraft.io/install/signal-desktop/arch
    #On Arch Linux, snap can be installed from the Arch User Repository (AUR). The manual build process is the Arch-supported install method for AUR packages, and you’ll need the prerequisites installed before you can install any AUR package. You can then install snap with the following:
    git clone https://aur.archlinux.org/snapd.git && cd snapd && makepkg -si && cd
    #Once installed, the systemd unit that manages the main snap communication socket needs to be enabled:
    sudo systemctl enable --now snapd.socket
    #To enable classic snap support, enter the following to create a symbolic link between /var/lib/snapd/snap and /snap:
    sudo ln -s /var/lib/snapd/snap /snap
    ###
    sudo snap install signal-desktop
    sudo snap install rpi-imager
    sudo snap install bitwarden
#
###Gaming:
    #>>https://discovery.endeavouros.com/gaming/gaming-101/2022/01/
    #>>https://vulkan.gpuinfo.org/
    #>>https://github.com/flightlessmango/MangoHud#installation
    #>>https://discovery.endeavouros.com/gaming/steam-lutris-wine/2022/01/
    #>>https://www.protondb.com/explore
    #>>https://github.com/ValveSoftware/Proton
    #>>https://lutris.net/games
    #>>https://github.com/lutris/lutris/wiki
    
    #https://www.addictivetips.com/ubuntu-linux-tips/gog-galaxy-on-linux/
    ##sudo snap install gog-galaxy-wine

    #https://www.reddit.com/r/ManjaroLinux/comments/jsuqxz/newbie_guide_to_manjaro_gaming/
    #sudo pacman -S lutris
#
###Enable multilib:
    #To enable multilib repository, uncomment the [multilib] section in /etc/pacman.conf
    #/etc/pacman.conf
    #--------------------------------------------------------------------------------------
    #[multilib]
    #Include = /etc/pacman.d/mirrorlist
#
###Wine Req:
    #sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
    #mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
    #lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
    #sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
    #ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
    #lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

    #sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-#loader

    #sudo pacman -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader

    #sudo pacman -S --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
###
###
###
