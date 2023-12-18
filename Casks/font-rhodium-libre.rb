cask "font-rhodium-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrhodiumlibreRhodiumLibre-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rhodium Libre"
  homepage "https:fonts.google.comspecimenRhodium+Libre"

  font "RhodiumLibre-Regular.ttf"

  # No zap stanza required
end