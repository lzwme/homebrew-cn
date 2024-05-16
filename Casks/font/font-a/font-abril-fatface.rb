cask "font-abril-fatface" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflabrilfatfaceAbrilFatface-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Abril Fatface"
  homepage "https:fonts.google.comspecimenAbril+Fatface"

  font "AbrilFatface-Regular.ttf"

  # No zap stanza required
end