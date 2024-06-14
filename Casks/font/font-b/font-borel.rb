cask "font-borel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflborelBorel-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Borel"
  homepage "https:fonts.google.comspecimenBorel"

  font "Borel-Regular.ttf"

  # No zap stanza required
end