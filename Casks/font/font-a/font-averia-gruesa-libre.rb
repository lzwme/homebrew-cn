cask "font-averia-gruesa-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaveriagruesalibreAveriaGruesaLibre-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Averia Gruesa Libre"
  homepage "https:fonts.google.comspecimenAveria+Gruesa+Libre"

  font "AveriaGruesaLibre-Regular.ttf"

  # No zap stanza required
end