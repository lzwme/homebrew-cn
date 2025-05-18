cask "font-playpen-sans-deva" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaypensansdevaPlaypenSansDeva%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playpen Sans Deva"
  homepage "https:fonts.google.comspecimenPlaypen+Sans+Deva"

  font "PlaypenSansDeva[wght].ttf"

  # No zap stanza required
end