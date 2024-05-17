cask "font-mr-bedfort" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmrbedfortMrBedfort-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mr Bedfort"
  homepage "https:fonts.google.comspecimenMr+Bedfort"

  font "MrBedfort-Regular.ttf"

  # No zap stanza required
end