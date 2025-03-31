cask "gramps" do
  arch arm: "Arm", intel: "Intel"

  version "6.0.0,2"
  sha256 arm:   "457a4bd5923509933c6a489de2a9a7f630f62f6d214c7c43d77ece93f165c08a",
         intel: "5d97df7382d227d1c6ff4bde20cb7ba5110d9fdfb3ff92ae0728ccf656fb630b"

  url "https:github.comgramps-projectgrampsreleasesdownloadv#{version.csv.first}Gramps-#{arch}-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.comgramps-projectgramps"
  name "Gramps"
  desc "Genealogy software"
  homepage "https:gramps-project.orgblog"

  livecheck do
    url :url
    regex(^Gramps[._-]#{arch}[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.dmg$i)
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

  app "Gramps.app"

  zap trash: [
    "~LibraryApplication Supportgramps",
    "~LibraryPreferencesorg.gramps-project.gramps.plist",
    "~LibrarySaved Application Stateorg.gramps-project.gramps.savedState",
  ]
end