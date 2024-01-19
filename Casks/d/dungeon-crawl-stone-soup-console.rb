cask "dungeon-crawl-stone-soup-console" do
  version "0.30.2"
  sha256 "b26aecdeef97c1c5d8aab8ffb704188e52008517db1c618e7fa1a54dbc89e200"

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