cask "font-delicious-handrawn" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldelicioushandrawnDeliciousHandrawn-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Delicious Handrawn"
  homepage "https:fonts.google.comspecimenDelicious+Handrawn"

  font "DeliciousHandrawn-Regular.ttf"

  # No zap stanza required
end