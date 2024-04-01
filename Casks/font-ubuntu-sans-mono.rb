cask "font-ubuntu-sans-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "uflubuntusansmono"
  name "Ubuntu Sans Mono"
  homepage "https:github.comcanonicalUbuntu-Sans-Mono-fonts"

  font "UbuntuSansMono-Italic[wght].ttf"
  font "UbuntuSansMono[wght].ttf"

  # No zap stanza required
end