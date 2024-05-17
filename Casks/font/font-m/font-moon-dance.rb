cask "font-moon-dance" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmoondanceMoonDance-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Moon Dance"
  homepage "https:fonts.google.comspecimenMoon+Dance"

  font "MoonDance-Regular.ttf"

  # No zap stanza required
end