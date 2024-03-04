cask "font-ojuju" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflojujuOjuju%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Ojuju"
  desc "Distinct with varying apertures as it moves from extra-light to bold"
  homepage "https:fonts.google.comspecimenOjuju"

  font "Ojuju[wght].ttf"

  # No zap stanza required
end