cask "heptabase" do
  arch arm: "-arm64"

  version "1.23.3"
  sha256 arm:   "9800f786e4d7266076306b87e09cb14c3a0f492e3df4e549e837a02b3ed98d0d",
         intel: "572a8a6949bb3e232e0dd8eb7c01f4af7477954c1c23045fea80cde13c8beeb4"

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