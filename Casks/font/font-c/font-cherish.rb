cask "font-cherish" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcherishCherish-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cherish"
  desc "Dry brush style that adds expression and sophistication"
  homepage "https:fonts.google.comspecimenCherish"

  font "Cherish-Regular.ttf"

  # No zap stanza required
end