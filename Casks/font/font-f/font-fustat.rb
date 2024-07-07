cask "font-fustat" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfustatFustat%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Fustat"
  homepage "https:fonts.google.comspecimenFustat"

  font "Fustat[wght].ttf"

  # No zap stanza required
end