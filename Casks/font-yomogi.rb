cask "font-yomogi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyomogiYomogi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Yomogi"
  homepage "https:fonts.google.comspecimenYomogi"

  font "Yomogi-Regular.ttf"

  # No zap stanza required
end