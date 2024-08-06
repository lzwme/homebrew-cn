cask "heptabase" do
  arch arm: "-arm64"

  version "1.35.3"
  sha256 arm:   "733f223f7ed14b3c6c86036639dde0b91ff08ed9d3065adb277e61784f60f018",
         intel: "2a0888c55973505cc80732f39bdfd28ca07440e9fa3c76e46bf90fd958388398"

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