cask "gramps" do
  arch arm: "Arm", intel: "Intel"

  version "5.2.2,1"
  sha256 arm:   "53904afc254ffbaa5c1a00a76f59258e948acc0f907e1909d4f2d858dd268556",
         intel: "1f5bd0d88bf457d5bc9648d2c4570fdc602ec049becac0296439f08625b8bc73"

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