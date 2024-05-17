cask "font-permanent-marker" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachepermanentmarkerPermanentMarker-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Permanent Marker"
  homepage "https:fonts.google.comspecimenPermanent+Marker"

  font "PermanentMarker-Regular.ttf"

  # No zap stanza required
end