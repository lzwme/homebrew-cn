cask "font-antonio" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflantonioAntonio%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Antonio"
  homepage "https:fonts.google.comspecimenAntonio"

  font "Antonio[wght].ttf"

  # No zap stanza required
end