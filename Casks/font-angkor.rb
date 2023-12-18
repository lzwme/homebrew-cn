cask "font-angkor" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflangkorAngkor-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Angkor"
  homepage "https:fonts.google.comspecimenAngkor"

  font "Angkor-Regular.ttf"

  # No zap stanza required
end