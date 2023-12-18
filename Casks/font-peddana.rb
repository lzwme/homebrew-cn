cask "font-peddana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpeddanaPeddana-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Peddana"
  homepage "https:fonts.google.comspecimenPeddana"

  font "Peddana-Regular.ttf"

  # No zap stanza required
end