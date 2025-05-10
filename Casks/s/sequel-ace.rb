cask "sequel-ace" do
  version "5.0.8,20094"
  sha256 "0c4f6d4c83dac1a03bfe97597dd715c86cd2897dec989cf6918cc16645e90829"

  url "https:github.comSequel-AceSequel-Acereleasesdownloadproduction#{version.csv.first}-#{version.csv.second}Sequel-Ace-#{version.csv.first}.zip"
  name "Sequel Ace"
  desc "MySQLMariaDB database management"
  homepage "https:github.comSequel-AceSequel-Ace"

  livecheck do
    url :url
    regex(%r{^productionv?(\d+(?:\.\d+)+)(?:-(\d+))?}i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map do |match|
        match[1].present? ? "#{match[0]},#{match[1]}" : match[0]
      end
    end
  end

  depends_on macos: ">= :monterey"

  app "Sequel Ace.app"

  zap trash: [
    "~LibraryApplication SupportSequel Ace",
    "~LibraryCachescom.sequelace.SequelAce",
    "~LibraryPreferencescom.sequelace.SequelAce.plist",
    "~LibrarySaved Application Statecom.sequelace.SequelAce.savedState",
  ]
end