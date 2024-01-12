cask "heptabase" do
  arch arm: "-arm64"

  version "1.20.0"
  sha256 arm:   "7aed5671648b8e6a0ff4c648aab85fb33976d7c3c66e1499ff9b73fa423a55df",
         intel: "dbe81a055f68797019e7899e67df4fd4ef84bb90754c3dc2e5df2a640e38fa6b"

  url "https:github.comheptametaproject-metareleasesdownloadv#{version}Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.comheptametaproject-meta"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https:heptabase.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end