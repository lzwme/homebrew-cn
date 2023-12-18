cask "font-peralta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflperaltaPeralta-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Peralta"
  homepage "https:fonts.google.comspecimenPeralta"

  font "Peralta-Regular.ttf"

  # No zap stanza required
end