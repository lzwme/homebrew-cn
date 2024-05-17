cask "font-poor-story" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpoorstoryPoorStory-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Poor Story"
  homepage "https:fonts.google.comspecimenPoor+Story"

  font "PoorStory-Regular.ttf"

  # No zap stanza required
end