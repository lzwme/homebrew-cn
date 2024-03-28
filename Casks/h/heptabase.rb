cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.5"
  sha256 arm:   "8813a725893d23f97acdda25e4d1b82314978e49216b4ca41c777527bbd3441e",
         intel: "959b265bfc9e32bb2b3121ba98102cc9862c6cec73832917dde738f0ea8b5b57"

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