cask "font-zen-dots" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflzendotsZenDots-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Zen Dots"
  desc "One of three latin fonts part of the zen fonts collection"
  homepage "https:fonts.google.comspecimenZen+Dots"

  font "ZenDots-Regular.ttf"

  # No zap stanza required
end