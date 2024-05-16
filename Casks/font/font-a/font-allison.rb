cask "font-allison" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflallisonAllison-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Allison"
  desc "Casual handwriting script"
  homepage "https:fonts.google.comspecimenAllison"

  font "Allison-Regular.ttf"

  # No zap stanza required
end