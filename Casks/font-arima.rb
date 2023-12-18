cask "font-arima" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflarimaArima%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Arima"
  desc "Led by ndiscover, a type design foundry based in portugal"
  homepage "https:fonts.google.comspecimenArima"

  font "Arima[wght].ttf"

  # No zap stanza required
end