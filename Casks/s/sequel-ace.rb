cask "sequel-ace" do
  version "5.0.5,20091"
  sha256 "cbeb4e6289afcfb4d37207e6c756a3278dd89fc79c194f8d49783cdbd6a1567f"

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