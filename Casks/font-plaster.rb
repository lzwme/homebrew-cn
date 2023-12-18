cask "font-plaster" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplasterPlaster-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Plaster"
  homepage "https:fonts.google.comspecimenPlaster"

  font "Plaster-Regular.ttf"

  # No zap stanza required
end