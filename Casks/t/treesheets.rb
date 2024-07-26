cask "treesheets" do
  version "10101933522"
  sha256 "61c32199dff3e29fc387abbba9005e5f6d720b0ed4ee37cffd01b2e7d36946dc"

  url "https:github.comaardappeltreesheetsreleasesdownload#{version}mac_treesheets.zip",
      verified: "github.comaardappeltreesheets"
  name "TreeSheets"
  desc "Hierarchical spreadsheet and outline application"
  homepage "https:strlen.comtreesheets"

  livecheck do
    url :url
    regex(^(\d+)$)
    strategy :github_latest
  end

  app "buildBuildProductsReleaseTreeSheets.app"

  uninstall quit: "dot3labs.TreeSheets"

  zap trash: [
    "~LibraryPreferencesdot3labs.TreeSheets.plist",
    "~LibraryPreferencesTreeSheets Preferences",
    "~LibrarySaved Application Statedot3labs.TreeSheets.savedState",
  ]
end