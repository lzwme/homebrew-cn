cask "font-danfo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldanfoDanfo%5BELSH%5D.ttf",
      verified: "github.comgooglefonts"
  name "Danfo"
  homepage "https:fonts.google.comspecimenDanfo"

  font "Danfo[ELSH].ttf"

  # No zap stanza required
end