$DOTFILES_ROOT="${HOME}\dotfiles\ps";

. "${DOTFILES_ROOT}\common.ps1";

load-parts("${DOTFILES_ROOT}\profile\parts\");
load-parts("${DOTFILES_ROOT}\profile\secrets\");

