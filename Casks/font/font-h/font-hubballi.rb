cask "font-hubballi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhubballiHubballi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hubballi"
  homepage "https:fonts.google.comspecimenHubballi"

  font "Hubballi-Regular.ttf"

  # No zap stanza required
end