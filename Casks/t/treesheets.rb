cask "treesheets" do
  version "11806628538"
  sha256 "d6651eda1ba684f66698da13ff3e9618b06083c51ef41b1ce7d89bf5eb3a5147"

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

  app "buildBuildProductsReleaseTreeSheets.app"

  uninstall quit: "dot3labs.TreeSheets"

  zap trash: [
    "~LibraryPreferencesdot3labs.TreeSheets.plist",
    "~LibraryPreferencesTreeSheets Preferences",
    "~LibrarySaved Application Statedot3labs.TreeSheets.savedState",
  ]
end