cask "font-felipa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfelipaFelipa-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Felipa"
  homepage "https:fonts.google.comspecimenFelipa"

  font "Felipa-Regular.ttf"

  # No zap stanza required
end