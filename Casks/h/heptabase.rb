cask "heptabase" do
  arch arm: "-arm64"

  version "1.34.0"
  sha256 arm:   "838b4b4444f8048332aaf029521af4f2bb9032aa13e32257f65a2fa9b63a0117",
         intel: "5fecc8fa0703463ba10b216497706c6b9facbab0abba70e115910aae07dee0f2"

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