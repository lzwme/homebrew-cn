cask "font-sura" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsura"
  name "Sura"
  homepage "https:fonts.google.comspecimenSura"

  font "Sura-Bold.ttf"
  font "Sura-Regular.ttf"

  # No zap stanza required
end