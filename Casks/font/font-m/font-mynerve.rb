cask "font-mynerve" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmynerveMynerve-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mynerve"
  homepage "https:fonts.google.comspecimenMynerve"

  font "Mynerve-Regular.ttf"

  # No zap stanza required
end