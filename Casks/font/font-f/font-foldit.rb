cask "font-foldit" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfolditFoldit%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Foldit"
  homepage "https:fonts.google.comspecimenFoldit"

  font "Foldit[wght].ttf"

  # No zap stanza required
end