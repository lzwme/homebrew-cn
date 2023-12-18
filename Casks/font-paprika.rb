cask "font-paprika" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpaprikaPaprika-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Paprika"
  homepage "https:fonts.google.comspecimenPaprika"

  font "Paprika-Regular.ttf"

  # No zap stanza required
end