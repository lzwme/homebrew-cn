cask "font-tapestry" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltapestryTapestry-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tapestry"
  desc "Roman calligraphic family with a slight rustic and country appearance"
  homepage "https:fonts.google.comspecimenTapestry"

  font "Tapestry-Regular.ttf"

  # No zap stanza required
end