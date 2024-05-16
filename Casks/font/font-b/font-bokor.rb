cask "font-bokor" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbokorBokor-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bokor"
  homepage "https:fonts.google.comspecimenBokor"

  font "Bokor-Regular.ttf"

  # No zap stanza required
end