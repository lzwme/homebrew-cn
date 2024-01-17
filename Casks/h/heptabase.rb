cask "heptabase" do
  arch arm: "-arm64"

  version "1.21.0"
  sha256 arm:   "dce77a27f859636f1a40717518dad31bf7f1d3e52cc395665eed4df0f5efa521",
         intel: "eb01646c91e4e3e2905c151db3040a844d6e0c619cd00373dbadb6b9750752d9"

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