cask "font-doto" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldotoDoto%5BROND%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Doto"
  homepage "https:fonts.google.comspecimenDoto"

  font "Doto[ROND,wght].ttf"

  # No zap stanza required
end