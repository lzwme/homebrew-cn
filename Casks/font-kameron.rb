cask "font-kameron" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkameronKameron%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Kameron"
  homepage "https:fonts.google.comspecimenKameron"

  font "Kameron[wght].ttf"

  # No zap stanza required
end