cask "font-shrikhand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshrikhandShrikhand-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shrikhand"
  homepage "https:fonts.google.comspecimenShrikhand"

  font "Shrikhand-Regular.ttf"

  # No zap stanza required
end