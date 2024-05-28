cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.14"
  sha256 arm:   "b59a6731bc7fec9012c56366fb2c9c595a97e790304c56cc9f8fe5e974f198d6",
         intel: "f1db807cebe39bcb7c8201d15e20c623b5f7314667b1eede637d90ecf8eff59c"

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