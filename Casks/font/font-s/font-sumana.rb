cask "font-sumana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsumana"
  name "Sumana"
  homepage "https:fonts.google.comspecimenSumana"

  font "Sumana-Bold.ttf"
  font "Sumana-Regular.ttf"

  # No zap stanza required
end