cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.5"
  sha256 arm:   "085909cdc642425565510094e7b698ccbe9dea5ab7ae9ca0f4e0ac21779ae483",
         intel: "dfa039988b71f7c569250d7d4d9295a1dafe229dd48f035610b2aa6fb4f65060"

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