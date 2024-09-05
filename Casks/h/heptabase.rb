cask "heptabase" do
  arch arm: "-arm64"

  version "1.36.0"
  sha256 arm:   "04ae2051e56de148c04917047dbe8a2622d5413615609ddf6a1be4e6bf5dd109",
         intel: "f12b436cd1f1e8797c8366802305540648787fb99f35465b731c5f54b69c6e25"

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