cask "font-jim-nightshade" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljimnightshadeJimNightshade-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jim Nightshade"
  homepage "https:fonts.google.comspecimenJim+Nightshade"

  font "JimNightshade-Regular.ttf"

  # No zap stanza required
end