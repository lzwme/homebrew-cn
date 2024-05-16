cask "font-coming-soon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachecomingsoonComingSoon-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Coming Soon"
  homepage "https:fonts.google.comspecimenComing+Soon"

  font "ComingSoon-Regular.ttf"

  # No zap stanza required
end