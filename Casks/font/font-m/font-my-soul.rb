cask "font-my-soul" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmysoulMySoul-Regular.ttf",
      verified: "github.comgooglefonts"
  name "My Soul"
  homepage "https:fonts.google.comspecimenMy+Soul"

  font "MySoul-Regular.ttf"

  # No zap stanza required
end