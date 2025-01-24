cask "heptabase" do
  arch arm: "-arm64"

  version "1.51.0"
  sha256 arm:   "f656b1368c58c8fdafd7c7354d8e9fdd313cf2790a12d141be642f5b26ee8c45",
         intel: "cfb32c5f080a22862b612d4fff445a1e43d3b7a794616bb11cb51725f43d57b0"

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
  depends_on macos: ">= :high_sierra"

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end