cask "font-consolas-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.comeugeiiconsolas-powerline-vimarchivemaster.zip"
  name "Consolas for Powerline"
  homepage "https:github.comeugeiiconsolas-powerline-vim"

  font "consolas-powerline-vim-masterCONSOLA-Powerline.ttf"
  font "consolas-powerline-vim-masterCONSOLAB-Powerline.ttf"
  font "consolas-powerline-vim-masterCONSOLAI-Powerline.ttf"
  font "consolas-powerline-vim-masterCONSOLAZ-Powerline.ttf"

  # No zap stanza required
end