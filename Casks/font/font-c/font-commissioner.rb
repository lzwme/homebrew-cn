cask "font-commissioner" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcommissionerCommissioner%5BFLAR%2CVOLM%2Cslnt%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Commissioner"
  homepage "https:fonts.google.comspecimenCommissioner"

  font "Commissioner[FLAR,VOLM,slnt,wght].ttf"

  # No zap stanza required
end