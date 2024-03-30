cask "gramps" do
  arch arm: "Arm", intel: "Intel"

  version "5.2.1,1"
  sha256 arm:   "5bd0ee8f0be478e2759a8a2a03a5ba4f3f36d02ab66ab028098c141024a57bd5",
         intel: "123490bda5acd7be829f4bb2fa7b61e68ff5cd0d1a10f91d97b5567424df2a8b"

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