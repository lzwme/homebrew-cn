cask "font-brawler" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbrawler"
  name "Brawler"
  homepage "https:fonts.google.comspecimenBrawler"

  font "Brawler-Bold.ttf"
  font "Brawler-Regular.ttf"

  # No zap stanza required
end