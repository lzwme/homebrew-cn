cask "dungeon-crawl-stone-soup-console" do
  version "0.32.0"
  sha256 "6ab2a0cc13c315e1e400b7e7f20fca2445c865b492525358ca9846026762e841"

  url "https:github.comcrawlcrawlreleasesdownload#{version}dcss-#{version}-macos-console-universal.zip",
      verified: "github.comcrawlcrawlreleases"
  name "Dungeon Crawl Stone Soup"
  desc "Game of dungeon exploration, combat and magic"
  homepage "https:crawl.develz.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Dungeon Crawl Stone Soup - Console.app"

  zap trash: "~LibraryApplication SupportDungeon Crawl Stone Soup"
end