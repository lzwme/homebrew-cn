cask "font-buda" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbudaBuda-Light.ttf",
      verified: "github.comgooglefonts"
  name "Buda"
  homepage "https:fonts.google.comspecimenBuda"

  font "Buda-Light.ttf"

  # No zap stanza required
end