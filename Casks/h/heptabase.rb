cask "heptabase" do
  arch arm: "-arm64"

  version "1.39.1"
  sha256 arm:   "74f3da4c0a524a74f58838f93192fe917fd4b5929abed651dfc064f39c94e7e8",
         intel: "aa874672c871b29b1f47496239967e81201c9de05bc30ff72e1ca113a886ad3e"

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