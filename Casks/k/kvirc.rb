cask "kvirc" do
  version "5.2.4,Quasar"
  sha256 "ca5320e0ab9521554f672ddaec9f47e3676150cba43015bb2627f63daae9a4f5"

  url "https:github.comkvircKVIrcreleasesdownload#{version.csv.first}KVIrc-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.comkvircKVIrc"
  name "KVIrc"
  desc "IRC Client"
  homepage "https:www.kvirc.net"

  livecheck do
    url :url
    regex(^KVIrc[._-]v?(\d+(?:\.\d+)+)[._-](\w+)\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          "#{match[1]},#{match[2]}"
        end
      end.flatten
    end
  end

  depends_on macos: ">= :high_sierra"

  app "KVIrc.app"

  zap trash: [
    "~.kvirc*.rc",
    "~LibraryPreferencescom.kvirc.kvirc.plist",
    "~LibrarySaved Application Statecom.kvirc.kvirc.savedState",
  ]
end