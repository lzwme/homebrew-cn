cask "font-merge-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmergeoneMergeOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Merge One"
  homepage "https:fonts.google.comspecimenMerge+One"

  font "MergeOne-Regular.ttf"

  # No zap stanza required
end