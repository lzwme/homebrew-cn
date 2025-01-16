cask "heptabase" do
  arch arm: "-arm64"

  version "1.50.2"
  sha256 arm:   "b7543ba84de5176a2e210e86ea004b7870cdf20f9ae5d801a0058dcd5df6bd8d",
         intel: "3d95436954768c6174303c548f109fc1f2489291c40062616aeb5882b3352d76"

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