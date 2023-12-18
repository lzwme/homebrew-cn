cask "redis-pro" do
  version "3.0.0"
  sha256 "202e046a4e2fa2e8f1ff2a94697695911ec28d05131a0290fa3d44974507f48f"

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