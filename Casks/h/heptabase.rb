cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.2"
  sha256 arm:   "723d47a9c364a6a340b02affbf5715dbf8defce17fa0e84f012dbc54c2d45a10",
         intel: "c18688f96fb15561bc7b1e456d77e433531112264a98f38ff5694217c64c140e"

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