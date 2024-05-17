cask "font-zen-antique" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflzenantiqueZenAntique-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Zen Antique"
  homepage "https:fonts.google.comspecimenZen+Antique"

  font "ZenAntique-Regular.ttf"

  # No zap stanza required
end