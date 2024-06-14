cask "font-reddit-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflredditmonoRedditMono%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Reddit Mono"
  homepage "https:fonts.google.comspecimenReddit+Mono"

  font "RedditMono[wght].ttf"

  # No zap stanza required
end