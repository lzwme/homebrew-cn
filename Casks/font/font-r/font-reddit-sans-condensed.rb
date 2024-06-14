cask "font-reddit-sans-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflredditsanscondensedRedditSansCondensed%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Reddit Sans Condensed"
  homepage "https:fonts.google.comspecimenReddit+Sans+Condensed"

  font "RedditSansCondensed[wght].ttf"

  # No zap stanza required
end