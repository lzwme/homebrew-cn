cask "font-asset" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflassetAsset-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Asset"
  homepage "https:fonts.google.comspecimenAsset"

  font "Asset-Regular.ttf"

  # No zap stanza required
end