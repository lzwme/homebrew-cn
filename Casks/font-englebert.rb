cask "font-englebert" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflenglebertEnglebert-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Englebert"
  homepage "https:fonts.google.comspecimenEnglebert"

  font "Englebert-Regular.ttf"

  # No zap stanza required
end