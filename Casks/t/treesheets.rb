cask "treesheets" do
  version "9882848653"
  sha256 "52e5260de891737ee6d32413121ec2a40a790b0dad27e5c59e561fcfb75d4523"

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