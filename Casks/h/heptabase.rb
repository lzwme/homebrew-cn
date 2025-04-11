cask "heptabase" do
  arch arm: "-arm64"

  version "1.55.2"
  sha256 arm:   "cf5dda0469701d34abcd2315fa7b0c5cfd76c5543284d78207ee0457791c7ba5",
         intel: "ce82570d0a082e1aa28b9f1add6c9f3f17050b7df5b2edc22ba5553d8d0fcd8d"

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