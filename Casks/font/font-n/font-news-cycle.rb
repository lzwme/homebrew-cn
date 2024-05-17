cask "font-news-cycle" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnewscycle"
  name "News Cycle"
  homepage "https:fonts.google.comspecimenNews+Cycle"

  font "NewsCycle-Bold.ttf"
  font "NewsCycle-Regular.ttf"

  # No zap stanza required
end