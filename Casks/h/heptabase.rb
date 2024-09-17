cask "heptabase" do
  arch arm: "-arm64"

  version "1.38.3"
  sha256 arm:   "777e250d4cf2254c7161388a7718030e9bcdb054b11e4b58b72627a7f13c58ff",
         intel: "1f9d796eeecc38c0209e984dbb49ceb9d6987db444b4c7c57d208a1ed608e952"

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