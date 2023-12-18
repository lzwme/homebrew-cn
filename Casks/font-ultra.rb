cask "font-ultra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheultraUltra-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ultra"
  homepage "https:fonts.google.comspecimenUltra"

  font "Ultra-Regular.ttf"

  # No zap stanza required
end