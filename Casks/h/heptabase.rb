cask "heptabase" do
  arch arm: "-arm64"

  version "1.19.0"
  sha256 arm:   "1d425d62e9f06821a6ab64bc1364c96fbe23bbfebeb9223b3b2d519d2606db6f",
         intel: "f2fc69ebfffeaa4a4cc8bda62fe5161d96845c4c3471b03402df0f324052205e"

  url "https:github.comheptametaproject-metareleasesdownloadv#{version}Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.comheptametaproject-meta"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https:heptabase.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Heptabase.app"

  zap trash: [
    "~LibraryPreferencesapp.projectmeta.projectmeta.plist",
    "~LibrarySaved Application Stateapp.projectmeta.projectmeta.savedState",
  ]
end