cask "font-podkova" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpodkovaPodkova%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Podkova"
  homepage "https:fonts.google.comspecimenPodkova"

  font "Podkova[wght].ttf"

  # No zap stanza required
end