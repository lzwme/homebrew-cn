cask "font-caesar-dressing" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcaesardressingCaesarDressing-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Caesar Dressing"
  homepage "https:fonts.google.comspecimenCaesar+Dressing"

  font "CaesarDressing-Regular.ttf"

  # No zap stanza required
end