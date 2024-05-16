cask "font-capriola" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcapriolaCapriola-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Capriola"
  homepage "https:fonts.google.comspecimenCapriola"

  font "Capriola-Regular.ttf"

  # No zap stanza required
end