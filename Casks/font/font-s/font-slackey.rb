cask "font-slackey" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheslackeySlackey-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Slackey"
  homepage "https:fonts.google.comspecimenSlackey"

  font "Slackey-Regular.ttf"

  # No zap stanza required
end