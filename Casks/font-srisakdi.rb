cask "font-srisakdi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsrisakdi"
  name "Srisakdi"
  homepage "https:fonts.google.comspecimenSrisakdi"

  font "Srisakdi-Bold.ttf"
  font "Srisakdi-Regular.ttf"

  # No zap stanza required
end