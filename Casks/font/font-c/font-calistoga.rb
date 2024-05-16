cask "font-calistoga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcalistogaCalistoga-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Calistoga"
  homepage "https:fonts.google.comspecimenCalistoga"

  font "Calistoga-Regular.ttf"

  # No zap stanza required
end