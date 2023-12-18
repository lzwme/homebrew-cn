cask "font-aladin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaladinAladin-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Aladin"
  homepage "https:fonts.google.comspecimenAladin"

  font "Aladin-Regular.ttf"

  # No zap stanza required
end