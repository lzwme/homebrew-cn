cask "font-vidaloka" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvidalokaVidaloka-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Vidaloka"
  homepage "https:fonts.google.comspecimenVidaloka"

  font "Vidaloka-Regular.ttf"

  # No zap stanza required
end