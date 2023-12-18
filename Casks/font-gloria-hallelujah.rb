cask "font-gloria-hallelujah" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgloriahallelujahGloriaHallelujah.ttf",
      verified: "github.comgooglefonts"
  name "Gloria Hallelujah"
  homepage "https:fonts.google.comspecimenGloria+Hallelujah"

  font "GloriaHallelujah.ttf"

  # No zap stanza required
end