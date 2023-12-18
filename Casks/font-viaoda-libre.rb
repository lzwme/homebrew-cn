cask "font-viaoda-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflviaodalibreViaodaLibre-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Viaoda Libre"
  homepage "https:fonts.google.comspecimenViaoda+Libre"

  font "ViaodaLibre-Regular.ttf"

  # No zap stanza required
end