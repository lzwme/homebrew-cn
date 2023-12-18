cask "font-overlock-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloverlockscOverlockSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Overlock SC"
  homepage "https:fonts.google.comspecimenOverlock+SC"

  font "OverlockSC-Regular.ttf"

  # No zap stanza required
end