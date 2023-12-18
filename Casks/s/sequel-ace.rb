cask "sequel-ace" do
  version "4.0.13,20062"
  sha256 "1ec331dd786b7fa89dfc5f57504559bcff6f079d9dd30f8bc73fa879d992ca1f"

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