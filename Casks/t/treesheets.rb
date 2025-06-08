cask "treesheets" do
  version "250607.1418,15508670937"
  sha256 "373bbf45375807ce867f101ddffde331fde8f6e404b9bf7c3a46269ed77cf10c"

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