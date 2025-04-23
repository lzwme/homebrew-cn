cask "heptabase" do
  arch arm: "-arm64"

  version "1.55.7"
  sha256 arm:   "de765433f585405168ed73f8185909718fa248e395a87718d78c018f597e8d30",
         intel: "9e83fb7e193190fb72e7d5df1d3331a9ece7438061ee7de1d5f2d1964c7b94c8"

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