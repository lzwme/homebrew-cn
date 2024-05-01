cask "treesheets" do
  version "8898778290"
  sha256 "7e71bd2ad5fbc84ce55208df3679c5d7a0cf4ec65ae48e8a2eb905b90a994e6a"

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