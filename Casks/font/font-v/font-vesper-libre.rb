cask "font-vesper-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflvesperlibre"
  name "Vesper Libre"
  homepage "https:fonts.google.comspecimenVesper+Libre"

  font "VesperLibre-Bold.ttf"
  font "VesperLibre-Heavy.ttf"
  font "VesperLibre-Medium.ttf"
  font "VesperLibre-Regular.ttf"

  # No zap stanza required
end