cask "heptabase" do
  arch arm: "-arm64"

  version "1.27.0"
  sha256 arm:   "63b917c4bc15e21663bf8bd90d61a74c08b23382bd1c28f4baf50383e6c957c5",
         intel: "2afdcb44236899654875a46f0b99b0b54726b6a1c0b60542e3c4a338ae08918d"

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