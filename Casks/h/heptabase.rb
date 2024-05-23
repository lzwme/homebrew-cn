cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.12"
  sha256 arm:   "7c884a51c807737b155a6284061af6b08653c4c3a169959a96d75fab60fb34d0",
         intel: "59724c49de2fb02d83f46622fff77280fb397a5721ffcee604a32de53a4d4e65"

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