cask "font-life-savers" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllifesavers"
  name "Life Savers"
  homepage "https:fonts.google.comspecimenLife+Savers"

  font "LifeSavers-Bold.ttf"
  font "LifeSavers-ExtraBold.ttf"
  font "LifeSavers-Regular.ttf"

  # No zap stanza required
end