cask "font-galindo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgalindoGalindo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Galindo"
  homepage "https:fonts.google.comspecimenGalindo"

  font "Galindo-Regular.ttf"

  # No zap stanza required
end