cask "font-miriam-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmiriamlibre"
  name "Miriam Libre"
  homepage "https:fonts.google.comspecimenMiriam+Libre"

  font "MiriamLibre-Bold.ttf"
  font "MiriamLibre-Regular.ttf"

  # No zap stanza required
end