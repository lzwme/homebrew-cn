cask "font-bilbo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbilboBilbo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bilbo"
  homepage "https:fonts.google.comspecimenBilbo"

  font "Bilbo-Regular.ttf"

  # No zap stanza required
end