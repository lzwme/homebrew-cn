cask "font-montaga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmontagaMontaga-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Montaga"
  homepage "https:fonts.google.comspecimenMontaga"

  font "Montaga-Regular.ttf"

  # No zap stanza required
end