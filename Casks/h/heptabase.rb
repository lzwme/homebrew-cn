cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.1"
  sha256 arm:   "b1346785ac2cec86e8b5c6958f78de72fbebe2394635afcd449737c2fbfd0844",
         intel: "9daf1899ee699515526fe36b5212d6803dec3b98f88c02b99894fc33e3cc96e8"

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