cask "sequel-ace" do
  version "4.2.1,20085"
  sha256 "77a392ad4cd67d30db92466f3dd0cb02ed4e57a4008375d44bb05b69138423ae"

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

  depends_on macos: ">= :high_sierra"

  app "Sequel Ace.app"

  zap trash: [
    "~LibraryApplication SupportSequel Ace",
    "~LibraryCachescom.sequelace.SequelAce",
    "~LibraryPreferencescom.sequelace.SequelAce.plist",
    "~LibrarySaved Application Statecom.sequelace.SequelAce.savedState",
  ]
end