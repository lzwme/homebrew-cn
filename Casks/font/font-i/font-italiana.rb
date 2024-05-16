cask "font-italiana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflitalianaItaliana-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Italiana"
  homepage "https:fonts.google.comspecimenItaliana"

  font "Italiana-Regular.ttf"

  # No zap stanza required
end