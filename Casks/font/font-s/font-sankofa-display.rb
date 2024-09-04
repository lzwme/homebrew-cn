cask "font-sankofa-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsankofadisplaySankofaDisplay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sankofa Display"
  homepage "https:fonts.google.comspecimenSankofa+Display"

  font "SankofaDisplay-Regular.ttf"

  # No zap stanza required
end