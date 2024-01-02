cask "heptabase" do
  arch arm: "-arm64"

  version "1.18.4"
  sha256 arm:   "5c356650d46b73a2bdaaa89e7dfa364bd3476b345ee11daff1c08c2dde9d53cc",
         intel: "9ab31751d24dd55b6e75f5859a2924615b9ae80d1de46e86223591bebf30c340"

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