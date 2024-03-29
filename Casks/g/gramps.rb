cask "gramps" do
  arch arm: "Arm", intel: "Intel"

  version "5.2.0,1"
  sha256 arm:   "af0162b9f6105c130e922187a9d0902b1c6a7544c68b7b30964f985c12f568a5",
         intel: "b5ec07f94d388b97d286a7a84eb7bfe32dcaf5c741b802caf146f4d81fbfc7e3"

  url "https:github.comgramps-projectgrampsreleasesdownloadv#{version.csv.first}Gramps-#{arch}-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.comgramps-projectgramps"
  name "Gramps"
  desc "Genealogy software"
  homepage "https:gramps-project.orgblog"

  livecheck do
    url :url
    regex(^Gramps[._-]#{arch}[._-]v?(\d+(?:.\d+)+)[._-](\d+)\.dmg$i)
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

  app "Gramps.app"

  zap trash: [
    "~LibraryApplication Supportgramps",
    "~LibraryPreferencesorg.gramps-project.gramps.plist",
    "~LibrarySaved Application Stateorg.gramps-project.gramps.savedState",
  ]
end