cask "font-carattere" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcarattereCarattere-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Carattere"
  desc "Perfect where formal elegance and beauty are essential"
  homepage "https:fonts.google.comspecimenCarattere"

  font "Carattere-Regular.ttf"

  # No zap stanza required
end