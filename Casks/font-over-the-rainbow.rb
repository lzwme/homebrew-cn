cask "font-over-the-rainbow" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflovertherainbowOvertheRainbow.ttf",
      verified: "github.comgooglefonts"
  name "Over the Rainbow"
  homepage "https:fonts.google.comspecimenOver+the+Rainbow"

  font "OvertheRainbow.ttf"

  # No zap stanza required
end