cask "treesheets" do
  version "11998744428"
  sha256 "c9f40c77f75a10d6451c5cb094a6ea8590ec9885ddd1cbd25bf119bb080af90b"

  url "https:github.comaardappeltreesheetsreleasesdownload#{version}mac_treesheets.zip",
      verified: "github.comaardappeltreesheets"
  name "TreeSheets"
  desc "Hierarchical spreadsheet and outline application"
  homepage "https:strlen.comtreesheets"

  livecheck do
    url :url
    regex(^(\d+)$i)
    strategy :github_latest
  end

  app "macos-bundletreesheets.app"

  uninstall quit: "dot3labs.TreeSheets"

  zap trash: [
    "~LibraryPreferencesdot3labs.TreeSheets.plist",
    "~LibraryPreferencesTreeSheets Preferences",
    "~LibrarySaved Application Statedot3labs.TreeSheets.savedState",
  ]
end