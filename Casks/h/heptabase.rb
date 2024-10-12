cask "heptabase" do
  arch arm: "-arm64"

  version "1.42.0"
  sha256 arm:   "440c4c3dbc7402646f87e2fc11e795e85e5360f5dcbf6fd15b7f331ed0a36171",
         intel: "0325a0d9cdbf4f8c9766b139cca46edea2621df2132cf91bd364c78927381c36"

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