cask "font-oldenburg" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloldenburgOldenburg-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Oldenburg"
  homepage "https:fonts.google.comspecimenOldenburg"

  font "Oldenburg-Regular.ttf"

  # No zap stanza required
end