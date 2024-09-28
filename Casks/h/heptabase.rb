cask "heptabase" do
  arch arm: "-arm64"

  version "1.40.1"
  sha256 arm:   "f299c6e1376f1298bf04d0881e203cb15a27b717673ae43f81ad25f888409317",
         intel: "76000cb72a6adad67463eb303c8ecd0d551b15c09f7c2b8f4537f040d9078712"

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