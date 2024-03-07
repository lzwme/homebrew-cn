cask "heptabase" do
  arch arm: "-arm64"

  version "1.29.6"
  sha256 arm:   "e57f166f62ff28c276091d1ef4186234a666c14b5c8a01e8752ffcabf6f55409",
         intel: "edc1be66022e32ae4794006e6fa74eaa94bd460ed68610ef0ff93c2b54952aa6"

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