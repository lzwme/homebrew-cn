cask "heptabase" do
  arch arm: "-arm64"

  version "1.58.2"
  sha256 arm:   "c9156d2e9150c55cdb614f27c29509351f09da074a3a8cd2cc8debc3c3c9c186",
         intel: "894a8b2a61a9fdeb743e3474f61fb2b8d9ff4c390bf16c83b6accdc75f2cf87a"

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
  depends_on macos: ">= :high_sierra"

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end