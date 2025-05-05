cask "dungeon-crawl-stone-soup-console" do
  version "0.33.0"
  sha256 "53b2c6d0357ec9f6111b31a335b7221e193c7b6e6174f49c06ddf73378342892"

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