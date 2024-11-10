cask "font-funnel-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfunneldisplayFunnelDisplay%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Funnel Display"
  homepage "https:fonts.google.comspecimenFunnel+Display"

  font "FunnelDisplay[wght].ttf"

  # No zap stanza required
end