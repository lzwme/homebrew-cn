cask "solar2d" do
  version "2025.3716"
  sha256 "2cb4f16fc8c4fa123008e95f5e89037861c9b9d18f2f1be6604d1971da7a2395"

  url "https:github.comcoronalabscoronareleasesdownload#{version.minor}Solar2D-macOS-#{version}.dmg",
      verified: "github.comcoronalabscorona"
  name "Solar2D"
  desc "Lua-based game engine"
  homepage "https:solar2d.com"

  livecheck do
    url :url
    regex(^Solar2D[._-]macOS[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  suite "Corona-#{version.minor}"

  zap trash: [
    "~LibraryApplication SupportCorona Simulator",
    "~LibraryApplication SupportCorona",
    "~LibraryPreferencescom.coronalabs.Corona_Simulator.plist",
    "~LibraryPreferencescom.coronalabs.CoronaConsole.plist",
    "~LibrarySaved Application Statecom.coronalabs.Corona_Simulator.savedState",
  ]
end