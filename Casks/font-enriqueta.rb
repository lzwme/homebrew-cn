cask "font-enriqueta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflenriqueta"
  name "Enriqueta"
  homepage "https:fonts.google.comspecimenEnriqueta"

  font "Enriqueta-Bold.ttf"
  font "Enriqueta-Medium.ttf"
  font "Enriqueta-Regular.ttf"
  font "Enriqueta-SemiBold.ttf"

  # No zap stanza required
end