MKDIR = mkdir -p
LN = ln -vsf
PACMAN = sudo pacman -S

DRIVERS = libva-mesa-driver mesa-vdpau

AUR := ani-cli-git simple-mtpfs

BASE := bc bluez bluez-utils calcurse clipmenu discord feh firefox fzf lazygit man ncdu pacman-contrib
BASE += playerctl powertop pulseaudio pulseaudio-bluetooth pulsemixer ripgrep scrot unclutter 
BASE += unzip wget words xclip yt-dlp  

FCITX5 := fcitx5-im fcitx5-hangul fcitx5-mozc 

FONTS := adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts ttf-hanazono ttf-joypixels

XORG := xdotool xf86-input-libinput xf86-video-amdgpu xf86-video-vesa xkeyboard-config 
XORG += xorg-fonts-encodings xorg-server xorg-server-common xorg-server-devel xorg-server-xephyr 
XORG += xorg-server-xnest xorg-server-xvfb xorg-setxkbmap xorg-smproxy xorg-util-macros xorg-x11perf 
XORG += xorg-xauth xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma 
XORG += xorg-xhost xorg-xinit xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms 
XORG += xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset 
XORG += xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xorgproto xsel

yay:
	$(MKDIR) $(HOME)/workspace/git/
	cd $(HOME)/workspace/git/
	git clone https://aur.archlinux.org/yay.git $(HOME)/workspace/git/yay
	cd $(HOME)/workspace/git/yay && makepkg -si
alacritty:
	$(PACMAN) alacritty
	$(LN) $(PWD)/alacritty.yml $(HOME)/.config/

base:
	$(PACMAN) $(BASE)
	sudo sed -i 's/\#Color/Color\nILoveCandy/' /etc/pacman.conf
	if [ $(uname --nodename) = "artix" ]; then
		sudo sed -i '/\# If you want to run .*/i \[universe\]\nServer \= https\:\/\/universe\.artixlinux\.org\/\$arch\n' /etc/pacman.conf
		$(PACMAN) artix-archlinux-support
		sudo pacman-key --populate archlinux
		sudo sed -i '/\# If you want to run .*/i \[extra\]\nInclude \= \/etc\/pacman.d\/mirrorlist-arch\n\n\[community\]\nInclude \= \/etc\/pacman.d\/mirrorlist-arch' /etc/pacman.conf
	fi

	yay -S $(AUR)

btop:
	$(PACMAN) btop
	$(MKDIR) $(HOME)/.config/btop/themes/
	git clone https://github.com/catppuccin/btop $(HOME)/workspace/git/catppuccin-btop
	cp $(HOME)/workspace/git/catppuccin-btop/catppuccin_mocha.theme $(HOME)/.config/btop/themes/

script:
	$(MKDIR) $(HOME)/.local/
	$(LN) $(PWD)/bin/ $(HOME)/.local/
discord: #discocss
	$(PACMAN) discord
	git clone https://github.com/mlvzk/discocss $(HOME)/workspace/git/discocss
	cd $(HOME)/workspace/git/discocss && sudo cp discocss /usr/bin
	git clone https://github.com/catppuccin/discord $(HOME)/workspace/git/catppuccin-discord
	$(MKDIR) $(HOME)/.config/discocss
	cd $(HOME)/workspace/git/catppuccin-discord && cp main.css $(HOME)/.config/discocss/custom.css

driver: 
	$(PACMAN) $(DRIVERS)
	sudo $(MKDIR) /etc/X11/xorg.conf.d/
	echo 'Section "Device" \n  Identifier  "AMD Graphics" \n  Driver      "amdgpu" \n  option      "TearFree"  "true" \nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-amd-gpu.conf

dunst:
	$(PACMAN) dunst
	$(MKDIR) $(HOME)/.config/dunst/
	$(LN) $(PWD)/dunstrc $(HOME)/.config/dunst/

dwm:
	make xorg
	$(PACMAN) libxinerama imlib2
	yay -S libxft-bgra nerd-fonts-jetbrains-mono
	$(MKDIR) $(HOME)/workspace/suckless
	git clone https://github.com/Johnsonnn64/dwm $(HOME)/workspace/suckless/dwm/
	$(MKDIR) $(HOME)/.local/share/fonts/
	cp $(HOME)/workspace/suckless/dwm/fonts/* $(HOME)/.local/share/fonts/
	cd $(HOME)/workspace/suckless/dwm/dwm && sudo make clean install
	git clone https://github.com/Johnsonnn64/newdmenu $(HOME)/workspace/suckless/dmenu/
	cd $(HOME)/workspace/suckless/dmenu/ && sudo make clean install

fcitx5:
	$(PACMAN) $(FCITX5)
	$(MKDIR) $(HOME)/.config/fcitx5/
	$(LN) $(PWD)/config $(HOME)/.config/fcitx5/
	$(LN) $(PWD)/profile $(HOME)/.config/fcitx5/

filemanager:
	yay -S lf
	$(PACMAN) ueberzug bat 
	$(LN) $(PWD)/lf $(HOME)/.config/
	$(MKDIR) $(HOME)/workspace/git/
	git clone https://github.com/cirala/lfimg $(HOME)/workspace/git/lfimg
	cd $(HOME)/workspace/git/lfimg && make install

fnkeys: 
	echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf

fonts:
	$(PACMAN) $(FONTS) 

keyd:
	yay -S keyd
	$(MKDIR) /etc/keyd/
	sudo $(LN) $(PWD)/default.conf /etc/keyd/

mpv:
	$(PACMAN) mpv
	$(MKDIR) $(HOME)/.config/mpv/
	$(LN) $(PWD)/input.conf $(HOME)/.config/mpv/

npm:
	$(PACMAN) npm
	$(MKDIR) $(HOME)/.config/npm/
	$(LN) $(PWD)/npmrc $(HOME)/.config/npm/

nsxiv:
	yay -S nsxiv
	$(MKDIR) $(HOME)/.config/nsxiv/exec/
	$(LN) $(PWD)/key-handler $(HOME)/.config/nsxiv/exec/

nvim:
	yay -S neovim-git
	$(MKDIR) $(HOME)/.config
	git clone https://github.com/Johnsonnn64/gitnvim $(HOME)/.config/nvim
	# TSInstall c cpp comment javascript lua nix python markdown markdown_inline html help
	# LspInstall clangd sumneko_lua html cssls tsserver bashls

pcspkr:
	$(MKDIR) /etc/modprobe.d/
	echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/blacklist.conf

picom:
	yay -S picom-jonaburg-fix
	$(MKDIR) $(HOME)/.config/picom/
	$(LN) $(PWD)/picom.conf $(HOME)/.config/picom/

qutebrowser:
	$(PACMAN) qutebrowser 
	$(LN) $(PWD)/qutebrowser/ $(HOME)/.config/

shell:
	$(PACMAN) zsh dash starship # dash for substitute of bash
	$(MKDIR) $(HOME)/.config/zsh/zplugins
	$(LN) $(PWD)/zsh/.zprofile $(HOME)/.config/zsh/.zprofile
	$(LN) $(PWD)/zsh/.zshrc $(HOME)/.config/zsh/.zshrc
	$(LN) $(PWD)/starship.toml $(HOME)/.config/starship.toml
	git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.config/zsh/zplugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting $(HOME)/.config/zsh/zplugins/zsh-syntax-highlighting
	$(MKDIR) /etc/zsh/
	echo 'emulate sh -c "source /etc/profile" \nsource "$(HOME)/.config/zsh/.zprofile"' | sudo tee /etc/zsh/zprofile
	echo 'export ZDOTDIR="$(HOME)/.config/zsh"' | sudo tee /etc/zsh/zshenv
	sudo chsh -s /bin/zsh john
	sudo chsh -s /bin/zsh
	sudo ln -sfT /bin/dash /bin/sh
	echo "[Trigger] \nType = Package \nOperation = Install \nOperation = Upgrade \nTarget = bash \n\n[Action] \nDescription = Re-pointing /bin/sh symlink to dash... \nWhen = PostTransaction \nExec = /usr/bin/ln -sfT dash /usr/bin/sh \nDepends = dash" | sudo tee /usr/share/libalpm/hooks/bash-update.hook

st:
	git clone https://github.com/Johnsonnn64/st $(HOME)/workspace/suckless/st
	cd $(HOME)/workspace/suckless/st && sudo make clean install

tlp:
	$(PACMAN) tlp
	sudo $(LN) $(PWD)/tlp.conf /etc/tlp.conf

xorg:
	$(PACMAN) $(XORG)
	$(LN) $(PWD)/x11 $(HOME)/.config/
	cat $(PWD)/xserverrc | sudo tee /etc/X11/xinit/xserverrc

pdf:
	$(PACMAN) zathura zathura-pdf-poppler
	$(LN) $(PWD)/zathura $(HOME)/.config/
ytmusic:
	yay -S youtube-music-bin
	$(MKDIR) $(HOME)/.config/YouTube\ Music/
	$(LN) $(PWD)/config.json $(HOME)/.config/YouTube\ Music/config.json

everything: 
	make yay base driver dunst dwm fcitx5 filemanager fnkeys fonts keyd mpv npm nsxiv pcspkr pdf picom qutebrowser script shell terminal tlp xorg zathura
