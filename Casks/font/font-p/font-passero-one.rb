cask "font-passero-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpasseroonePasseroOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Passero One"
  homepage "https:fonts.google.comspecimenPassero+One"

  font "PasseroOne-Regular.ttf"

  # No zap stanza required
end