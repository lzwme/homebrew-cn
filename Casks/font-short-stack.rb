cask "font-short-stack" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshortstackShortStack-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Short Stack"
  homepage "https:fonts.google.comspecimenShort+Stack"

  font "ShortStack-Regular.ttf"

  # No zap stanza required
end