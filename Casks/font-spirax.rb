cask "font-spirax" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflspiraxSpirax-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Spirax"
  homepage "https:fonts.google.comspecimenSpirax"

  font "Spirax-Regular.ttf"

  # No zap stanza required
end