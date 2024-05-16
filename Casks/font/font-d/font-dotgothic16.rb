cask "font-dotgothic16" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldotgothic16DotGothic16-Regular.ttf",
      verified: "github.comgooglefonts"
  name "DotGothic16"
  homepage "https:fonts.google.comspecimenDotGothic16"

  font "DotGothic16-Regular.ttf"

  # No zap stanza required
end