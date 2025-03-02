cask "heptabase" do
  arch arm: "-arm64"

  version "1.53.4"
  sha256 arm:   "0faaeddf3d512bf056537d06c3ff5eb2cb241c41dbb9fa7fbbe3a567127d90d9",
         intel: "68c122c2754f0f320023c4b5c63e389e13f09f39254a57d428b682ff0edc9f98"

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
  depends_on macos: ">= :high_sierra"

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end