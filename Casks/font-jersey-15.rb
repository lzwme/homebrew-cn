cask "font-jersey-15" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljersey15Jersey15-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jersey 15"
  homepage "https:fonts.google.comspecimenJersey+15"

  font "Jersey15-Regular.ttf"

  # No zap stanza required
end