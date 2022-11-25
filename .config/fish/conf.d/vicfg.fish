# function vicfg
#     set CFG $HOME/.config/nvim/
#     GIT_DIR="$(yadm rev-parse --git-dir)" nvim -c "lcd $CFG" $CFG
# end

function vicfg
    pushd "$HOME/.config/nvim/"
    GIT_DIR="$(yadm rev-parse --git-dir)" nvim .
    popd
end
