cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.4"
  sha256 arm:   "dd46c4dbce65de1512ceb336edb9c17b404dcbbce1ae773f3533be85676f5160",
         intel: "80ca0a3b5b63868051be218203e2c4b78e1b960c63a4b05a1f380171fddb3efb"

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