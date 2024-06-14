cask "heptabase" do
  arch arm: "-arm64"

  version "1.32.17"
  sha256 arm:   "14fb59d754c40beea513de9b081ca25b135375f53ca0ddad88dc6e76b34ccd5c",
         intel: "bfb54e7983d18ace085b450fbeee623d3ca62d07430b26137e3aa3febf8474a2"

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