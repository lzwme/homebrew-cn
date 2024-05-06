cask "font-reddit-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflredditsans"
  name "Reddit Sans"
  desc "Complemented by reddit sans condensed and reddit mono"
  homepage "https:fonts.google.comspecimenReddit+Sans"

  font "RedditSans-Italic[wght].ttf"
  font "RedditSans[wght].ttf"

  # No zap stanza required
end