cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.19"
  sha256 arm:   "d549ae2b2e559c1b535ab005b3f6397773036189f72a46342e88165ebebaa8a1",
         intel: "4d15ab835138cadfdbc06caa8ec944a1c3a0c52242c5fcff5e0e6cb7fd91be12"

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