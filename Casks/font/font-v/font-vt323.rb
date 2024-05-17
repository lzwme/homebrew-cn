cask "font-vt323" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvt323VT323-Regular.ttf",
      verified: "github.comgooglefonts"
  name "VT323"
  homepage "https:fonts.google.comspecimenVT323"

  font "VT323-Regular.ttf"

  # No zap stanza required
end