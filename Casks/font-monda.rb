cask "font-monda" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmonda"
  name "Monda"
  homepage "https:fonts.google.comspecimenMonda"

  font "Monda-Bold.ttf"
  font "Monda-Regular.ttf"

  # No zap stanza required
end