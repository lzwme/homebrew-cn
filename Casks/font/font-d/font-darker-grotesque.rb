cask "font-darker-grotesque" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldarkergrotesqueDarkerGrotesque%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Darker Grotesque"
  homepage "https:fonts.google.comspecimenDarker+Grotesque"

  font "DarkerGrotesque[wght].ttf"

  # No zap stanza required
end