cask "font-menlo-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.comabertschMenlo-for-Powerlinearchiverefsheadsmaster.tar.gz"
  name "Menlo for Powerline"
  homepage "https:github.comabertschMenlo-for-Powerline"

  font "Menlo-for-Powerline-masterMenlo for Powerline.ttf"
  font "Menlo-for-Powerline-masterMenlo Bold for Powerline.ttf"
  font "Menlo-for-Powerline-masterMenlo Italic for Powerline.ttf"
  font "Menlo-for-Powerline-masterMenlo Bold Italic for Powerline.ttf"

  # No zap stanza required
end