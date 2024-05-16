cask "font-cantora-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcantoraoneCantoraOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cantora One"
  homepage "https:fonts.google.comspecimenCantora+One"

  font "CantoraOne-Regular.ttf"

  # No zap stanza required
end