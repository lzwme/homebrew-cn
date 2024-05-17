cask "font-waterfall" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwaterfallWaterfall-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Waterfall"
  desc "Calligraphic script"
  homepage "https:fonts.google.comspecimenWaterfall"

  font "Waterfall-Regular.ttf"

  # No zap stanza required
end