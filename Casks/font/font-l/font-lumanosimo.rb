cask "font-lumanosimo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllumanosimoLumanosimo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lumanosimo"
  desc "Expressive typeface"
  homepage "https:fonts.google.comspecimenLumanosimo"

  font "Lumanosimo-Regular.ttf"

  # No zap stanza required
end