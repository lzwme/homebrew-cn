cask "heptabase" do
  arch arm: "-arm64"

  version "1.30.4"
  sha256 arm:   "afe507898ff6188a568752ce596c53a85eb157b4d61d04f58146df47bd7dd313",
         intel: "6ad4bf7af4705fc19f76db53dd1a75434a92c14547cb28101d1d6b0025beb0ec"

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