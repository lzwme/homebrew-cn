cask "mechvibes" do
  version "2.3.6-hotfix,2.3.6"
  sha256 "29db0b74bdde3895e4d7b38165eebb1dec91ae546244be9d1285123999b4326a"

  url "https:github.comhainguyents13mechvibesreleasesdownloadv#{version.csv.second || version.csv.first}Mechvibes-#{version.csv.first}.dmg",
      verified: "github.comhainguyents13mechvibes"
  name "Mechvibes"
  desc "Play mechanical keyboard sounds as you type"
  homepage "https:mechvibes.com"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)Mechvibes[._-]v?(\d+(?:\.\d+)+(?:-hotfix)?)\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        (match[2] == match[1]) ? match[1] : "#{match[2]},#{match[1]}"
      end
    end
  end

  app "Mechvibes.app"

  zap trash: [
        "~LibraryApplication SupportMechvibes",
        "~LibraryPreferencescom.electron.mechvibes.plist",
        "~LibrarySaved Application Statecom.electron.mechvibes.savedState",
      ],
      rmdir: "~mechvibes_custom"

  caveats do
    requires_rosetta
  end
end