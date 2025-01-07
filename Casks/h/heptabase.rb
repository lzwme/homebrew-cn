cask "heptabase" do
  arch arm: "-arm64"

  version "1.50.1"
  sha256 arm:   "3888b1d1f752705eb44f94536f043c65e6e99107a1676cf45f37e8bca74eafae",
         intel: "1f99b3573fecb4585ab030ac00751c659b2e9f148d8ca559be8236e452b14c60"

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