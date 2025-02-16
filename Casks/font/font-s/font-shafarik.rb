cask "font-shafarik" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshafarikShafarik-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shafarik"
  homepage "https:fonts.google.comspecimenShafarik"

  font "Shafarik-Regular.ttf"

  # No zap stanza required
end