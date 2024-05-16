cask "font-alata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalataAlata-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Alata"
  homepage "https:fonts.google.comspecimenAlata"

  font "Alata-Regular.ttf"

  # No zap stanza required
end