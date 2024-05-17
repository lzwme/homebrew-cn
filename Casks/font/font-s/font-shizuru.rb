cask "font-shizuru" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflshizuruShizuru-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Shizuru"
  homepage "https:fonts.google.comspecimenShizuru"

  font "Shizuru-Regular.ttf"

  # No zap stanza required
end