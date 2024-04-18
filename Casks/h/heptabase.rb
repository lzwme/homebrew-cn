cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.16"
  sha256 arm:   "5437ac123b7ed52f7ab26a1fea8410f956b5f50a2ab58f245ca15c20d2f1c58b",
         intel: "e4b43f8821286d057ebfadcce7ca613e01a26693112c6604a9ce8396ecf4d6c0"

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