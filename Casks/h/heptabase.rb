cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.15"
  sha256 arm:   "faa20191faec0baf6aed17ea2fe9eb7f42977dee9ef94088d74484f2f5b97a63",
         intel: "8ff87b67d681896073e7a10f08fec29c27aa0608f8b6997033bb708b4b7d71b4"

  url "https:github.comheptametaproject-metareleasesdownloadv#{version}Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.comheptametaproject-meta"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https:heptabase.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end