cask "heptabase" do
  arch arm: "-arm64"

  version "1.22.1"
  sha256 arm:   "ca4e3b26d905d9163ac4de23677898189fb70e6c303e004318625ad4983408eb",
         intel: "bf964708bef32b11aa3e40a84b399bf5160ac6b6cbf92b92d0cea0e9c31d54fa"

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