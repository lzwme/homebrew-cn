cask "font-cherish" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcherishCherish-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cherish"
  homepage "https:fonts.google.comspecimenCherish"

  font "Cherish-Regular.ttf"

  # No zap stanza required
end