cask "heptabase" do
  arch arm: "-arm64"

  version "1.28.0"
  sha256 arm:   "0235ca3b3a22b20038960a2a94ec4969fd6326d7632d8c51bc633f9978b9c833",
         intel: "f7c7d8fa95a23490c359a5d7a33509b1ae2039312fd5847f5a5326c07e828164"

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