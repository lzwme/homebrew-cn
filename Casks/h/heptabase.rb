cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.13"
  sha256 arm:   "227599378d0902b99b17ae32c5c3d1f3b49fab4290185d37d858f2342d339c78",
         intel: "3e4ee731e3ae6f1be640b6008cb5a9ee5a371c6c9fd1868ad1cc95ed350e963f"

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