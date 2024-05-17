cask "font-sahitya" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsahitya"
  name "Sahitya"
  homepage "https:fonts.google.comspecimenSahitya"

  font "Sahitya-Bold.ttf"
  font "Sahitya-Regular.ttf"

  # No zap stanza required
end