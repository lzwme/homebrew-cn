cask "font-dynapuff" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldynapuffDynaPuff%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "DynaPuff"
  homepage "https:fonts.google.comspecimenDynaPuff"

  font "DynaPuff[wdth,wght].ttf"

  # No zap stanza required
end