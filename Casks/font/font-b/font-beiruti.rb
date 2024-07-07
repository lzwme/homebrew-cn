cask "font-beiruti" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbeirutiBeiruti%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Beiruti"
  homepage "https:fonts.google.comspecimenBeiruti"

  font "Beiruti[wght].ttf"

  # No zap stanza required
end