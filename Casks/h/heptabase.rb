cask "heptabase" do
  arch arm: "-arm64"

  version "1.40.0"
  sha256 arm:   "a638991f44aa7099def5add23ed3c6da621ebabe1234241d6a93b61ce5992b45",
         intel: "6ac50a38e98a103d0d3706451b8aa4e4e684e614bde08388d050b81c081b6d3c"

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