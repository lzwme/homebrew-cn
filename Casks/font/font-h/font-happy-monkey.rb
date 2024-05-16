cask "font-happy-monkey" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhappymonkeyHappyMonkey-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Happy Monkey"
  homepage "https:fonts.google.comspecimenHappy+Monkey"

  font "HappyMonkey-Regular.ttf"

  # No zap stanza required
end