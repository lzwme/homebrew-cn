cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.3"
  sha256 arm:   "b7d19c254733553bc5c4b023d0d5964843ead326eedbaeb807b5a4d31132a659",
         intel: "bcdd5db27b48ccf5bb32c60bc47ed0231035e8d716e172362e6b5fe2e0074506"

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