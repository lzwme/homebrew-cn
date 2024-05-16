cask "font-galdeano" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgaldeanoGaldeano-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Galdeano"
  homepage "https:fonts.google.comspecimenGaldeano"

  font "Galdeano-Regular.ttf"

  # No zap stanza required
end