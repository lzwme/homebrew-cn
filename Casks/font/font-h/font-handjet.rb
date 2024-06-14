cask "font-handjet" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhandjetHandjet%5BELGR%2CELSH%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Handjet"
  homepage "https:fonts.google.comspecimenHandjet"

  font "Handjet[ELGR,ELSH,wght].ttf"

  # No zap stanza required
end