cask "font-lugrasimo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllugrasimoLugrasimo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lugrasimo"
  homepage "https:fonts.google.comspecimenLugrasimo"

  font "Lugrasimo-Regular.ttf"

  # No zap stanza required
end