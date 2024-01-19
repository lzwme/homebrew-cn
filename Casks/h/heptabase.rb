cask "heptabase" do
  arch arm: "-arm64"

  version "1.22.0"
  sha256 arm:   "6da92c0bb3958a434bae797ccbbdd8c81dc88056e7e2e4b0f640c8c6a3034b51",
         intel: "a13827898ac3d41d5475db331f639e5ba102d6da7a725645dd29c804185ed0b7"

  url "https:github.comheptametaproject-metareleasesdownloadv#{version}Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.comheptametaproject-meta"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https:heptabase.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end