cask "font-ranchers" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflranchersRanchers-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Ranchers"
  homepage "https:fonts.google.comspecimenRanchers"

  font "Ranchers-Regular.ttf"

  # No zap stanza required
end