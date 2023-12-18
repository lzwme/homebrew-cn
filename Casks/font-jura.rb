cask "font-jura" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljuraJura%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Jura"
  homepage "https:fonts.google.comspecimenJura"

  font "Jura[wght].ttf"

  # No zap stanza required
end