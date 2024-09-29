cask "heptabase" do
  arch arm: "-arm64"

  version "1.40.2"
  sha256 arm:   "7e8669f411a16e5f4c419758dbee227fdfbd4551a5f900dfcbde5045f001f222",
         intel: "81067d7a0fe97bdf21ad5ed974531487e82edb4bb2757d73b3b59d3875ab61b5"

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