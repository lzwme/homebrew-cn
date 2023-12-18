cask "font-patrick-hand-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpatrickhandscPatrickHandSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Patrick Hand SC"
  homepage "https:fonts.google.comspecimenPatrick+Hand+SC"

  font "PatrickHandSC-Regular.ttf"

  # No zap stanza required
end