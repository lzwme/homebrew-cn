cask "font-ms-madi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmsmadiMsMadi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ms Madi"
  homepage "https:fonts.google.comspecimenMs+Madi"

  font "MsMadi-Regular.ttf"

  # No zap stanza required
end