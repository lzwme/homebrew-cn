cask "font-devonshire" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldevonshireDevonshire-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Devonshire"
  homepage "https:fonts.google.comspecimenDevonshire"

  font "Devonshire-Regular.ttf"

  # No zap stanza required
end