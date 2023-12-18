cask "font-electrolize" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflelectrolizeElectrolize-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Electrolize"
  homepage "https:fonts.google.comspecimenElectrolize"

  font "Electrolize-Regular.ttf"

  # No zap stanza required
end