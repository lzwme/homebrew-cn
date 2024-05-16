cask "font-inconsolata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflinconsolataInconsolata%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Inconsolata"
  homepage "https:fonts.google.comspecimenInconsolata"

  font "Inconsolata[wdth,wght].ttf"

  # No zap stanza required
end