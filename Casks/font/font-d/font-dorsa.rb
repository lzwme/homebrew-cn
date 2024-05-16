cask "font-dorsa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldorsaDorsa-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dorsa"
  homepage "https:fonts.google.comspecimenDorsa"

  font "Dorsa-Regular.ttf"

  # No zap stanza required
end