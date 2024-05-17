cask "font-metal" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmetalMetal-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Metal"
  homepage "https:fonts.google.comspecimenMetal"

  font "Metal-Regular.ttf"

  # No zap stanza required
end