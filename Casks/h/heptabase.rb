cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.11"
  sha256 arm:   "2cdb2fdce164cf83b39d7dff6bbbbe7d30b137310d0425aa80bf79f60470138d",
         intel: "46b5ec47a8aff8fa2ac7cf3e78b7edb981ff9d916219692c06ca9eb2fcc7de80"

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