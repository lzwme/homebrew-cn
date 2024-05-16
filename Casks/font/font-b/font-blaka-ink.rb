cask "font-blaka-ink" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflblakainkBlakaInk-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Blaka Ink"
  homepage "https:fonts.google.comspecimenBlaka+Ink"

  font "BlakaInk-Regular.ttf"

  # No zap stanza required
end