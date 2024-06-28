cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.21"
  sha256 arm:   "424b2e572a00763f153010367e960a216ab867b12e698f8adf57c70f98734d45",
         intel: "07d463c3d5cda3ec586d9bbd2463b02e98b6fee1fd771a34d530ed432992862a"

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