cask "font-goldman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgoldman"
  name "Goldman"
  desc "Latin display typeface designed for posters"
  homepage "https:fonts.google.comspecimenGoldman"

  font "Goldman-Bold.ttf"
  font "Goldman-Regular.ttf"

  # No zap stanza required
end