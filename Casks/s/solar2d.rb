cask "solar2d" do
  version "2024.3709"
  sha256 "e6c16e0851dc6d280720ab947f1f5c60fbff2f94b8176d084fbd476d7a38e934"

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