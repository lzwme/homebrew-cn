cask "heptabase" do
  arch arm: "-arm64"

  version "1.55.4"
  sha256 arm:   "7f5742b68c09d54d95900d89ae36808d254f339b541ee60d38339ae798cb4b32",
         intel: "1eb223b39739a4fc6136ab125c64e116ae60c4bba26903ebe400c0b234c80759"

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