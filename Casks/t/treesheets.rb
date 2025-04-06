cask "treesheets" do
  version "250405.0951,14280748468"
  sha256 "1851146698d7916021d49391a6aa10dd768a919689830445b31a943c28dcdb21"

  url "https:github.comaardappeltreesheetsreleasesdownload#{version.csv.second}TreeSheets-#{version.csv.first}-Darwin.dmg",
      verified: "github.comaardappeltreesheets"
  name "TreeSheets"
  desc "Hierarchical spreadsheet and outline application"
  homepage "https:strlen.comtreesheets"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)*)TreeSheets[._-]v?(\d+(?:\.\d+)+)(?:[._-]Darwin)?\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  depends_on macos: ">= :catalina"

  app "TreeSheets.app"

  uninstall quit: "dot3labs.TreeSheets"

  zap trash: [
    "~LibraryPreferencesdot3labs.TreeSheets.plist",
    "~LibraryPreferencesTreeSheets Preferences",
    "~LibrarySaved Application Statedot3labs.TreeSheets.savedState",
  ]
end