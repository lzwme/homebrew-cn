cask "dungeon-crawl-stone-soup-tiles" do
  version "0.32.1"
  sha256 "b3c78742c8f453b2e910f08cdabb6be483bacc4910745410202937fce8cce4a1"

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