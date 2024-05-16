cask "font-bree-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbreeserifBreeSerif-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bree Serif"
  homepage "https:fonts.google.comspecimenBree+Serif"

  font "BreeSerif-Regular.ttf"

  # No zap stanza required
end