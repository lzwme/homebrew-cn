cask "heptabase" do
  arch arm: "-arm64"

  version "1.30.5"
  sha256 arm:   "5b6e6a1199d440b03349cf5c5e1a3b79f0a6b6d2eb998f5db9507688cfa2b2eb",
         intel: "4aba896fc24173b5db903c0198d8e30594ae862aab39da9f02fbe519bdce67fc"

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