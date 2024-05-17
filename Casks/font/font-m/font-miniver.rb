cask "font-miniver" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflminiverMiniver-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Miniver"
  homepage "https:fonts.google.comspecimenMiniver"

  font "Miniver-Regular.ttf"

  # No zap stanza required
end