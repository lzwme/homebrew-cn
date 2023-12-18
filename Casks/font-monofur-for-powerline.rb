cask "font-monofur-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.compowerlinefonts.git",
      branch:    "master",
      only_path: "Monofur"
  name "monofur for Powerline"
  homepage "https:github.compowerlinefontstreemasterMonofur"

  font "Monofur Bold for Powerline.ttf"
  font "Monofur Italic for Powerline.ttf"
  font "Monofur for Powerline.ttf"

  # No zap stanza required
end