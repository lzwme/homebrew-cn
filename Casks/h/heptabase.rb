cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.18"
  sha256 arm:   "67fbb02af7e0b16537255dbd211250486458ed6a069ada85c9cadfca7c078c26",
         intel: "34e69d3f8962ae98b978199e0b6d3db74601348467ff2b1be35d5883ef862dd8"

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