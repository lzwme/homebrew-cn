cask "font-shippori-mincho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflshipporimincho"
  name "Shippori Mincho"
  desc "Based on the Tsukiji Typeface making facility of Tokyo"
  homepage "https:fonts.google.comspecimenShippori+Mincho"

  font "ShipporiMincho-Bold.ttf"
  font "ShipporiMincho-ExtraBold.ttf"
  font "ShipporiMincho-Medium.ttf"
  font "ShipporiMincho-Regular.ttf"
  font "ShipporiMincho-SemiBold.ttf"

  # No zap stanza required
end