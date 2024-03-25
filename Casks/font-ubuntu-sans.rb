cask "font-ubuntu-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "uflubuntusans"
  name "Ubuntu Sans"
  homepage "https:github.comcanonicalUbuntu-Sans-fonts"

  font "UbuntuSans-Italic[wdth,wght].ttf"
  font "UbuntuSans[wdth,wght].ttf"

  # No zap stanza required
end