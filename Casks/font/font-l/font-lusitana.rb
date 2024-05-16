cask "font-lusitana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllusitana"
  name "Lusitana"
  homepage "https:fonts.google.comspecimenLusitana"

  font "Lusitana-Bold.ttf"
  font "Lusitana-Regular.ttf"

  # No zap stanza required
end