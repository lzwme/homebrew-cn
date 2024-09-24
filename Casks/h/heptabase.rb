cask "heptabase" do
  arch arm: "-arm64"

  version "1.39.2"
  sha256 arm:   "e45e30990f589146a282e284a614f81adb8a299b0c6b674eade0bd51f6cbf710",
         intel: "7fb20bc69a000ebbcae876e46ac97dfe3efd588e49d4987adea9387745c27c2c"

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