cask "font-notable" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotableNotable-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Notable"
  homepage "https:fonts.google.comspecimenNotable"

  font "Notable-Regular.ttf"

  # No zap stanza required
end