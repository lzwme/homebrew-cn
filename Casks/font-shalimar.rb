cask "font-shalimar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshalimarShalimar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shalimar"
  desc "Upright script inspired by the calligraphic strokes of a flat nib pen"
  homepage "https:fonts.google.comspecimenShalimar"

  font "Shalimar-Regular.ttf"

  # No zap stanza required
end