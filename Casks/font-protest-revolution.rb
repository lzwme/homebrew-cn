cask "font-protest-revolution" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprotestrevolutionProtestRevolution-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Protest Revolution"
  homepage "https:fonts.google.comspecimenProtest+Revolution"

  font "ProtestRevolution-Regular.ttf"

  # No zap stanza required
end