cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.10"
  sha256 arm:   "69921430e53d56c267e7e61940542551959f2d832ffe6bbb6ed3cad327535dd5",
         intel: "62b3508dcf54da5a1d47e238ec24c20a313c11edce1b575a7f7b9cee2aa289e9"

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