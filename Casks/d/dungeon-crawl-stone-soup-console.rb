cask "dungeon-crawl-stone-soup-console" do
  version "0.32.1"
  sha256 "09c4f8f5ed581e399a5aca877cf10da49bb1586339f724136010c14b405356a0"

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