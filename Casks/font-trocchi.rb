cask "font-trocchi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltrocchiTrocchi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Trocchi"
  homepage "https:fonts.google.comspecimenTrocchi"

  font "Trocchi-Regular.ttf"

  # No zap stanza required
end