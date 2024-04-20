cask "heptabase" do
  arch arm: "-arm64"

  version "1.31.17"
  sha256 arm:   "ad4836166676b94d3572dfe586dbee2838d45d45ae023fa4b437b4db5436d9c5",
         intel: "aaa35ec176d641a5ebaf5a8e565a45835939ef72ec92e9a086b3f9b0c12e80dd"

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