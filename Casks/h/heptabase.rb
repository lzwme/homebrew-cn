cask "heptabase" do
  arch arm: "-arm64"

  version "1.30.1"
  sha256 arm:   "28fffa87364413238fc0647f759d5eee1d08560c500115067628c5efe7c4122a",
         intel: "a4a30fa8f9afb984640d6e957ee5d4e4b44e26abe8444fac1ebb18740cfb4fef"

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