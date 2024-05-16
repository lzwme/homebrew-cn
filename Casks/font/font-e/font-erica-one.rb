cask "font-erica-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflericaoneEricaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Erica One"
  homepage "https:fonts.google.comspecimenErica+One"

  font "EricaOne-Regular.ttf"

  # No zap stanza required
end