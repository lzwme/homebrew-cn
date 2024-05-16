cask "font-kenia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkeniaKenia-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kenia"
  homepage "https:fonts.google.comspecimenKenia"

  font "Kenia-Regular.ttf"

  # No zap stanza required
end