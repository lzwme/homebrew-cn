cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.9"
  sha256 arm:   "4ff6785f195b3290f6db8903798d84aac6a1180fafe50caac15ab9803953b8dd",
         intel: "437cc0120b8d7ebf4d9e6ec482702af270069770df293cf797a64625172fc4b5"

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