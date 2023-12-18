cask "font-kavoon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkavoonKavoon-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Kavoon"
  homepage "https:fonts.google.comspecimenKavoon"

  font "Kavoon-Regular.ttf"

  # No zap stanza required
end