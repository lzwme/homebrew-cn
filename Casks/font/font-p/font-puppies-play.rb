cask "font-puppies-play" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpuppiesplayPuppiesPlay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Puppies Play"
  homepage "https:fonts.google.comspecimenPuppies+Play"

  font "PuppiesPlay-Regular.ttf"

  # No zap stanza required
end