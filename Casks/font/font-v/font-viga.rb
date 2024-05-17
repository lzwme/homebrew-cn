cask "font-viga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvigaViga-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Viga"
  homepage "https:fonts.google.comspecimenViga"

  font "Viga-Regular.ttf"

  # No zap stanza required
end