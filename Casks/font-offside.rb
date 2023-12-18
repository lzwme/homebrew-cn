cask "font-offside" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloffsideOffside-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Offside"
  homepage "https:fonts.google.comspecimenOffside"

  font "Offside-Regular.ttf"

  # No zap stanza required
end