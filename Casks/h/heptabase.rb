cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.12"
  sha256 arm:   "97099839d32832f73f2a25c6c41ac2fd9eefc32d108e1791c1f445cb0181423d",
         intel: "d3850a15e54849d73562eaeafda4b793e28717eb21153b6597e4a62124310191"

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