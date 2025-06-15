cask "mechvibes" do
  version "2.3.4"
  sha256 "ba1d345a8c1eb7ff9445e0621b2a9bd2e051a2e92541323dde5d4051f78acef0"

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

  no_autobump! because: :requires_manual_review

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