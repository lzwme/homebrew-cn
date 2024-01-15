cask "redis-pro" do
  version "3.1.0"
  sha256 "d7e408a5a7f409bd47e841cb2e48670820a19029f73737ec60a86eb75dda28f6"

  url "https:github.comcmushroomredis-proreleasesdownload#{version}redis-pro.dmg"
  name "redis-pro"
  desc "Redis desktop"
  homepage "https:github.comcmushroomredis-pro"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "redis-pro.app"

  zap trash: [
    "~LibraryApplication Scriptscom.cmushroom.redis-pro",
    "~LibraryApplication Supportcom.cmushroom.redis-pro",
    "~LibraryCachescom.cmushroom.redis-pro",
    "~LibraryContainerscom.cmushroom.redis-pro",
    "~LibraryPreferencescom.cmushroom.redis-pro.plist",
    "~LibrarySaved Application Statecom.cmushroom.redis-pro.savedState",
  ]
end