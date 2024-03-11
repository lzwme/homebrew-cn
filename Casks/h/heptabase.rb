cask "heptabase" do
  arch arm: "-arm64"

  version "1.30.0"
  sha256 arm:   "23c809d0eb21ca8c8ec092485b018310dd41db8b46893b9786fe3384d4fe49cd",
         intel: "4122e792ccaf055b2130b4fa11594e3f3ebd87d9751685df6a4b8197fea8913c"

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