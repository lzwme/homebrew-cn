cask "font-abyssinica-sil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflabyssinicasilAbyssinicaSIL-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Abyssinica SIL"
  homepage "https:fonts.google.comspecimenAbyssinica+SIL"

  font "AbyssinicaSIL-Regular.ttf"

  # No zap stanza required
end