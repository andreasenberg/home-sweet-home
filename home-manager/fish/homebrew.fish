if test -e /opt/homebrew/bin/brew
    # Source exported vars from brew (if installed)
    /opt/homebrew/bin/brew shellenv | source
end
