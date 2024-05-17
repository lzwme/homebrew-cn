cask "font-warnes" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwarnesWarnes-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Warnes"
  homepage "https:fonts.google.comspecimenWarnes"

  font "Warnes-Regular.ttf"

  # No zap stanza required
end