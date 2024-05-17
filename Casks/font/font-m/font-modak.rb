cask "font-modak" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmodakModak-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Modak"
  homepage "https:fonts.google.comspecimenModak"

  font "Modak-Regular.ttf"

  # No zap stanza required
end