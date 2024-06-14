cask "font-ballet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflballetBallet%5Bopsz%5D.ttf",
      verified: "github.comgooglefonts"
  name "Ballet"
  homepage "https:fonts.google.comspecimenBallet"

  font "Ballet[opsz].ttf"

  # No zap stanza required
end