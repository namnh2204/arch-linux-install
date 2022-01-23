#!/usr/bin/python
import os
import sys
import configparser
import time
import subprocess as sp

cp = configparser.ConfigParser(allow_no_value=True)
cp.read('packages.ini')
username = sp.getoutput('whoami')
#proxy = 'http://10.61.11.42:3128'
#os.environ['http_proxy']=proxy
#os.environ['https_proxy']=proxy
#os.environ['HTTP_PROXY']=proxy
#os.environ['HTTPS_PROXY']=proxy


def cprint( fmt, fg=None, bg=None, style=None ):
    """
    Colour-printer.

        cprint( 'Hello!' )                                  # normal
        cprint( 'Hello!', fg='g' )                          # green
        cprint( 'Hello!', fg='r', bg='w', style='bx' )      # bold red blinking on white

    List of colours (for fg and bg):
        k   black
        r   red
        g   green
        y   yellow
        b   blue
        m   magenta
        c   cyan
        w   white

    List of styles:
        b   bold
        i   italic
        u   underline
        s   strikethrough
        x   blinking
        r   reverse
        y   fast blinking
        f   faint
        h   hide
    """

    COLCODE = {
        'k': 0, # black
        'r': 1, # red
        'g': 2, # green
        'y': 3, # yellow
        'b': 4, # blue
        'm': 5, # magenta
        'c': 6, # cyan
        'w': 7  # white
    }

    FMTCODE = {
        'b': 1, # bold
        'f': 2, # faint
        'i': 3, # italic
        'u': 4, # underline
        'x': 5, # blinking
        'y': 6, # fast blinking
        'r': 7, # reverse
        'h': 8, # hide
        's': 9, # strikethrough
    }

    # properties
    props = []
    if isinstance(style,str):
        props = [ FMTCODE[s] for s in style ]
    if isinstance(fg,str):
        props.append( 30 + COLCODE[fg] )
    if isinstance(bg,str):
        props.append( 40 + COLCODE[bg] )

    # display
    props = ';'.join([ str(x) for x in props ])
    if props:
        print( '\x1b[%sm%s\x1b[0m' % (props, fmt) )
    else:
        print( fmt )



def cmd(parameter):
    os.system(parameter)
    

def pause():
    time.sleep(1)


def showWelcomeScreen():
    cprint('===========================================================', fg='y', style='b')
    cprint(':: Arch-Linux Installer ::', fg='g', style='b')
    cprint('https://github.com/namnh2204/arch-linux-install', fg='c', style='b')
    cprint('===========================================================', fg='y', style='b')
    pause()


def installRegularPackages():
    cprint('\r\n:: Installing Regular packages...', fg='y', style='b')
    regPkgs = ''
    for pkg in cp['Regular']:
        regPkgs = regPkgs + pkg + ' '

    print(regPkgs)
    os.system(f'sudo pacman --noconfirm -S {regPkgs}')
    pause()

def installYayAurHelper():
    cprint('\r\n:: Install Yay AUR Helper...', fg='y', style='b')
    os.system('git clone https://aur.archlinux.org/yay.git') 
    os.chdir('yay')
    os.system('makepkg -si')
    os.chdir('../')
    os.system('rm -rf yay')
    pause()

def installAurPkgs():
    cprint('\r\n:: Installing AUR packages...', fg='y', style='b')
    for pkg in cp['AUR']:
        os.system(f'yay --noconfirm -S {pkg}')

    pause()


def installDotFiles():
    # if ~/.config not exists, so create
    cprint('\r\n:: Installing dotfiles...', fg='y', style='b')
    os.system('git clone https://github.com/namnh2204/dotfiles.git ~/')
    pause()


def setupLightDM():
    cprint('\r\n:: Configuration LightDM...', fg='y', style='b')
    os.system(f'sudo systemctl start lightdm')
    os.system(f'sudo systemctl enable lightdm')
    os.system(f'sudo cp -rf {os.getcwd()}/wall/neon.png /usr/share/pixmaps/')
    os.system(f'sudo cp -rf {os.getcwd()}/lightdm/lightdm.conf /etc/lightdm/')
    os.system(f'sudo cp -rf {os.getcwd()}/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/')


def updateAndUpgrade():
    cprint('\r\n:: Update and Upgrading your system...', fg='y', style='b')
    os.system('sudo pacman --noconfirm -Syyu')


def installTmuxPluginManager():
    cprint('\r\n:: Install Tmux Plugin Manager...', fg='y', style='b')
    os.system('git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm') 
    pause()


def postInstallZsh():
    cprint('\r\n:: Install ohmyzsh...', fg='y', style='b')
    os.system('sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')
    cprint('\r\n:: Install zsh-autosuggestions...', fg='y', style='b')
    os.system('git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions')


def showFinalMessage():
    cprint('\r\n:: Everything ok...', fg='y', style='b')
    input('Press any key to REBOOT!')
    os.system('reboot')


def main():
    showWelcomeScreen()
    #updateAndUpgrade()
    #installRegularPackages()
    #installYayAurHelper()
    #installAurPkgs()
    #installTmuxPluginManager()
    postInstallZsh()
    #installDotFiles()
    #setupLightDM()
    #showFinalMessage()
    

if __name__ == "__main__":
    main()
