cask "heptabase" do
  arch arm: "-arm64"

  version "1.29.1"
  sha256 arm:   "8890afe940fd8bdbece3370de933edbff619353e9048dfbdc3f585ff2dcd5570",
         intel: "f7b4525d924c3a816a1d83c78c9db33d6c679a7881c7a26dc73b86543883747b"

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