cask "font-yusei-magic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyuseimagicYuseiMagic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yusei Magic"
  homepage "https:fonts.google.comspecimenYusei+Magic"

  font "YuseiMagic-Regular.ttf"

  # No zap stanza required
end