cask "font-puppies-play" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpuppiesplayPuppiesPlay-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Puppies Play"
  desc "Fun, bouncy script with connectors that give a playful flow"
  homepage "https:fonts.google.comspecimenPuppies+Play"

  font "PuppiesPlay-Regular.ttf"

  # No zap stanza required
end