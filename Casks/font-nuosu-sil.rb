cask "font-nuosu-sil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnuosusilNuosuSIL-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nuosu SIL"
  homepage "https:fonts.google.comspecimenNuosu+SIL"

  font "NuosuSIL-Regular.ttf"

  # No zap stanza required
end