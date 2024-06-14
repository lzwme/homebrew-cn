cask "font-ar-one-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaronesansAROneSans%5BARRR%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "AR One Sans"
  homepage "https:fonts.google.comspecimenAR+One+Sans"

  font "AROneSans[ARRR,wght].ttf"

  # No zap stanza required
end