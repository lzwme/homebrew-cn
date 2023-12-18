cask "font-esteban" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflestebanEsteban-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Esteban"
  homepage "https:fonts.google.comspecimenEsteban"

  font "Esteban-Regular.ttf"

  # No zap stanza required
end