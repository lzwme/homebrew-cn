cask "font-saira" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsaira"
  name "Saira"
  homepage "https:fonts.google.comspecimenSaira"

  font "Saira-Italic[wdth,wght].ttf"
  font "Saira[wdth,wght].ttf"

  # No zap stanza required
end