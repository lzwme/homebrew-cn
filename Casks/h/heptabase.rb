cask "heptabase" do
  arch arm: "-arm64"

  version "1.26.0"
  sha256 arm:   "576c5c87e647aab81dc368975c95544f22ee27a31554ce293b42114e44aec77c",
         intel: "a541afaad8cbffdabfdfb585e52a7b4a104bab25fda4256aca4c55b6bc551be3"

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