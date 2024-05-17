cask "font-stix-two-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflstixtwotext"
  name "STIX Two Text"
  homepage "https:fonts.google.comspecimenSTIX+Two+Text"

  font "STIXTwoText-Italic[wght].ttf"
  font "STIXTwoText[wght].ttf"

  # No zap stanza required
end