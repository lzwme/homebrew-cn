cask "gramps" do
  arch arm: "Arm", intel: "Intel"

  version "5.1.6,1"
  sha256 arm:   "a7a8b3ea24a7acf09112b7414183d54136df90308388d780b66f2a366af428f3",
         intel: "456add4d982bf98750935069efd93b2cdd96d888ad4f7d6d5e938d820730558e"

  url "https:github.comgramps-projectgrampsreleasesdownloadv#{version.csv.first}Gramps-#{arch}-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.comgramps-projectgramps"
  name "Gramps"
  desc "Genealogy software"
  homepage "https:gramps-project.orgblog"

  livecheck do
    url :url
    regex(^Gramps[._-]#{arch}[._-]v?(\d+(?:.\d+)+)[._-](\d+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  app "Gramps.app"

  zap trash: [
    "~LibraryApplication Supportgramps",
    "~LibraryPreferencesorg.gramps-project.gramps.plist",
    "~LibrarySaved Application Stateorg.gramps-project.gramps.savedState",
  ]
end