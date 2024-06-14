cask "font-ojuju" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflojujuOjuju%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Ojuju"
  homepage "https:fonts.google.comspecimenOjuju"

  font "Ojuju[wght].ttf"

  # No zap stanza required
end