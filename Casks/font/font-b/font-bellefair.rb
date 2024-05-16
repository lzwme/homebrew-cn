cask "font-bellefair" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbellefairBellefair-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bellefair"
  homepage "https:fonts.google.comspecimenBellefair"

  font "Bellefair-Regular.ttf"

  # No zap stanza required
end