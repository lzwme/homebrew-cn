cask "font-lilita-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllilitaoneLilitaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lilita One"
  homepage "https:fonts.google.comspecimenLilita+One"

  font "LilitaOne-Regular.ttf"

  # No zap stanza required
end