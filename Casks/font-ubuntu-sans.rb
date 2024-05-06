cask "font-ubuntu-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "uflubuntusans"
  name "Ubuntu Sans"
  homepage "https:fonts.google.comspecimenUbuntu+Sans"

  font "UbuntuSans-Italic[wdth,wght].ttf"
  font "UbuntuSans[wdth,wght].ttf"

  # No zap stanza required
end