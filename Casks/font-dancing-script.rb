cask "font-dancing-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldancingscriptDancingScript%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Dancing Script"
  homepage "https:fonts.google.comspecimenDancing+Script"

  font "DancingScript[wght].ttf"

  # No zap stanza required
end