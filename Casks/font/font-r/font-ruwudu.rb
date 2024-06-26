cask "font-ruwudu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflruwudu"
  name "Ruwudu"
  homepage "https:fonts.google.comspecimenRuwudu"

  font "Ruwudu-Bold.ttf"
  font "Ruwudu-Medium.ttf"
  font "Ruwudu-Regular.ttf"
  font "Ruwudu-SemiBold.ttf"

  # No zap stanza required
end