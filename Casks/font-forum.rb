cask "font-forum" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflforumForum-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Forum"
  homepage "https:fonts.google.comspecimenForum"

  font "Forum-Regular.ttf"

  # No zap stanza required
end