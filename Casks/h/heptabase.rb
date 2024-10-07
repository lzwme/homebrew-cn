cask "heptabase" do
  arch arm: "-arm64"

  version "1.41.1"
  sha256 arm:   "195765bb64aa87b730d7ba02503a133f4efdff2a62ad1b856dd4d45cdf5a92a1",
         intel: "5db818a1d75e1610e33c151dcfde4acab7e2ff6ab243d2692f237d015962857b"

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