cask "heptabase" do
  arch arm: "-arm64"

  version "1.17.3"
  sha256 arm:   "41a420cd08c4eb5216d83db9c17731aa10fc0e8f5cfa760d2b2f15a7d99887d8",
         intel: "28aca074d71052ee66ce453b39b7356c36cf84bfc1de8fb575eb1ae2f3410ed7"

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