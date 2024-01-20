cask "dungeon-crawl-stone-soup-tiles" do
  version "0.31.0"
  sha256 "1a5fb6a7fbb79194db9566f1bdf26e9db215802ef60b4a53dd318b8ad4464d05"

  url "https:github.comcrawlcrawlreleasesdownload#{version}dcss-#{version}-macos-tiles-universal.zip",
      verified: "github.comcrawlcrawlreleases"
  name "Dungeon Crawl Stone Soup"
  desc "Game of dungeon exploration, combat and magic"
  homepage "https:crawl.develz.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Dungeon Crawl Stone Soup - Tiles.app"

  zap trash: [
    "~LibraryApplication SupportDungeon Crawl Stone Soup",
    "~LibrarySaved Application Statenet.sourceforge.crawl-ref.savedState",
  ]
end