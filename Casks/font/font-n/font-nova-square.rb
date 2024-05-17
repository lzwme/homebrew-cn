cask "font-nova-square" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnovasquareNovaSquare.ttf",
      verified: "github.comgooglefonts"
  name "Nova Square"
  homepage "https:fonts.google.comspecimenNova+Square"

  font "NovaSquare.ttf"

  # No zap stanza required
end