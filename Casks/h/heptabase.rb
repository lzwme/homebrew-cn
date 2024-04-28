cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.0"
  sha256 arm:   "934a53f6c7190f2a3955899cdc9ca4a0707588edb692028afc44a920f8f4af6e",
         intel: "a10f04a06b22a4b7dcc82a808edcab34afc3f809f6c806ee3aafb3a60d6f6b18"

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