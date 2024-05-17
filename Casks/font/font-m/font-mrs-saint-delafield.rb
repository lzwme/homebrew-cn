cask "font-mrs-saint-delafield" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmrssaintdelafieldMrsSaintDelafield-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mrs Saint Delafield"
  homepage "https:fonts.google.comspecimenMrs+Saint+Delafield"

  font "MrsSaintDelafield-Regular.ttf"

  # No zap stanza required
end