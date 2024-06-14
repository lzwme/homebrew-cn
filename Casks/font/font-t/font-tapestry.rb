cask "font-tapestry" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltapestryTapestry-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tapestry"
  homepage "https:fonts.google.comspecimenTapestry"

  font "Tapestry-Regular.ttf"

  # No zap stanza required
end