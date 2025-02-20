cask "heptabase" do
  arch arm: "-arm64"

  version "1.53.1"
  sha256 arm:   "ecf0ef3cc19453c24d8d0dd82bac2b13ce2019c10047383ea7a6d1092ebb6faf",
         intel: "6b9d9f48e20a5a7c4d999aa7742f67f92f213ecc9c8b4a6150af96e9b99d2ecd"

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