cask "heptabase" do
  arch arm: "-arm64"

  version "1.50.0"
  sha256 arm:   "5ae5810e789bfb688a178b8a6a3db15205885e756964a0ccad57ae132f43b7e5",
         intel: "39d905f5ca1cff1819304192c6d66d378023a8690432f53183b5a14fd6338630"

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