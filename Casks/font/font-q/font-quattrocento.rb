cask "font-quattrocento" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflquattrocento"
  name "Quattrocento"
  homepage "https:fonts.google.comspecimenQuattrocento"

  font "Quattrocento-Bold.ttf"
  font "Quattrocento-Regular.ttf"

  # No zap stanza required
end