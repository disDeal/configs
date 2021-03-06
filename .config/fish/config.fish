abbr -a g git
abbr -a gc 'git checkout'
abbr -a ga 'git add -p'
abbr -a vimdiff 'nvim -d'
abbr -a ct 'cargo t'

alias o=xdg-open
alias c=cargo
alias ccw='cargo clippy 2>&1 | rg -i --multiline "(^error.*\n.*)|(aborting)|(warnings)"'
alias cck="cargo watch -s 'cargo clippy --color always 2>&1 | less -R'"

alias tmux="TERM=screen-256color-bce tmux"

export EDITOR="vim -i"

alias psr=procs

alias dur=dust

alias nv=nvim

alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$HOME/bins:$PATH"
export PATH="$HOME/.whale/bin:$PATH"
export PATH="$HOME/HOME/third_party/zig:$PATH"
export PATH="$HOME/HOME/third_party/zls/zig-out/bin:$PATH"

export GPG_TTY=(tty)

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opam configuration
export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/firefox

bind -M insert \t accept-autosuggestion
set fish_greeting

bass source ~/HOME/third_party/vulkan/1.2.176.1/setup-env.sh
# export VULKAN_SDK=~/HOME/third_party/vulkan/1.2.176.1/x86_64
# export PATH=$VULKAN_SDK/bin:$PATH
# export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
# export VK_LAYER_PATH=$VULKAN_SDK/etc/vulkan/explicit_layer.d

function _z_cd
    cd $argv
    or return $status

    commandline -f repaint

    if test "$_ZO_ECHO" = "1"
        echo $PWD
    end
end

function z
    set argc (count $argv)

    if test $argc -eq 0
        _z_cd $HOME
    else if begin; test $argc -eq 1; and test $argv[1] = '-'; end
        _z_cd -
    else
        set -l _zoxide_result (zoxide query -- $argv)
        and _z_cd $_zoxide_result
    end
end

function zi
    set -l _zoxide_result (zoxide query -i -- $argv)
    and _z_cd $_zoxide_result
end


abbr -a za 'zoxide add'

abbr -a zq 'zoxide query'
abbr -a zqi 'zoxide query -i'

abbr -a zr 'zoxide remove'
function zri
    set -l _zoxide_result (zoxide query -i -- $argv)
    and zoxide remove $_zoxide_result
end


function _zoxide_hook --on-variable PWD
    zoxide add (pwd -L)
end

if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ls 'exa'
	abbr -a ll 'exa -l'
    abbr -a le 'exa -a'
    abbr -a lt 'exa -aT'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# For RLS
# https://github.com/fish-shell/fish-shell/issues/2456
# setenv LD_LIBRARY_PATH (rustc +nightly --print sysroot)"/lib:$LD_LIBRARY_PATH"
# setenv RUST_SRC_PATH (rustc --print sysroot)"/lib/rustlib/src/rust/src"

setenv FZF_DEFAULT_COMMAND 'fd --type file --follow'
setenv FZF_CTRL_T_COMMAND 'fd --type file --follow'
setenv FZF_DEFAULT_OPTS '--height 20%'

function ex --description "Universal archive extractor script"
    for file in $argv
        switch $file
            case '*.tar.bz2'
                tar xjf $file
            case '*.tar.gz'
                tar xzf $file
            case '*bz2'
                bunzip2  $file
            case '*.rar'
                unrar x  $file
            case '*.tar'
                tar xf  $file
            case '*.tbz2'
                tar xjf $file
            case '*.tgz'
                tar xzf $file
            case '*.zip'
                unzip  $file -d (echo $file | sed 's/\.[^.]*$//')
            case '*.Z'
                uncompress  $file
            case '*.7z'
                7z x  $file
            case '*'
                echo "$file cannot be extracted via ex()"
        end
    end
end
