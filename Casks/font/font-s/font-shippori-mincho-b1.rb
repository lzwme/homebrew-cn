cask "font-shippori-mincho-b1" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflshipporiminchob1"
  name "Shippori Mincho B1"
  homepage "https:fonts.google.comspecimenShippori+Mincho+B1"

  font "ShipporiMinchoB1-Bold.ttf"
  font "ShipporiMinchoB1-ExtraBold.ttf"
  font "ShipporiMinchoB1-Medium.ttf"
  font "ShipporiMinchoB1-Regular.ttf"
  font "ShipporiMinchoB1-SemiBold.ttf"

  # No zap stanza required
end