cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.19"
  sha256 arm:   "87d38ea3bf692595059a3abeae5dc05d87338612d16f6d340875edabd480d838",
         intel: "01709847b15df9690336cf0c72b126b79786441031f5f1d4d2b2e0c4c55ad12b"

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