cask "solar2d" do
  version "2025.3720"
  sha256 "29dc81c4ba02b8d92dd23e46d08156f5589a428efb82e79fd6d2b1dfd6518318"

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