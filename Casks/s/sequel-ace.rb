cask "sequel-ace" do
  version "4.0.16,20066"
  sha256 "68ac0af011ce9c51a4c74c5ac9a40218e9e67bf55ebe13c8f2d758f710a3163a"

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

  app "Sequel Ace.app"

  zap trash: [
    "~LibraryApplication SupportSequel Ace",
    "~LibraryCachescom.sequelace.SequelAce",
    "~LibraryPreferencescom.sequelace.SequelAce.plist",
    "~LibrarySaved Application Statecom.sequelace.SequelAce.savedState",
  ]
end