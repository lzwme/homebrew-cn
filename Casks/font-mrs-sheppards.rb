cask "font-mrs-sheppards" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmrssheppardsMrsSheppards-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mrs Sheppards"
  homepage "https:fonts.google.comspecimenMrs+Sheppards"

  font "MrsSheppards-Regular.ttf"

  # No zap stanza required
end