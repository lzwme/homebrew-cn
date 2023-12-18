cask "font-oswald" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloswaldOswald%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Oswald"
  homepage "https:fonts.google.comspecimenOswald"

  font "Oswald[wght].ttf"

  # No zap stanza required
end