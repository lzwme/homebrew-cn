cask "psychopy" do
  version "2024.2.2,2024-09-18_18-17"
  sha256 "9c5f1471d103c24e33985f64569dbe3a8b7ecf06a8659e6a72d174980597286f"

  url "https:github.compsychopypsychopyreleasesdownload#{version.csv.first.major_minor_patch}StandalonePsychoPy-#{version.csv.first}-macOS#{"_#{version.csv.second}" if version.csv.second}_3.10.dmg"
  name "PsychoPy"
  desc "Create experiments in behavioral science"
  homepage "https:github.compsychopypsychopy"

  livecheck do
    url :url
    regex(StandalonePsychoPy[._-]v?(\d+(?:\.\d+)+)[._-]macOS[._-](\d+(?:[._-]\d+)+)?[._-](?:py)?3\.10\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[2].present? ? "#{match[1]},#{match[2]}" : match[1]
        end
      end.flatten
    end
  end

  app "PsychoPy.app"

  zap trash: [
    "~.psychopy3",
    "~LibraryPreferencesorg.opensciencetools.psychopy.plist",
    "~LibrarySaved Application Stateorg.opensciencetools.psychopy.savedState",
  ]

  caveats do
    requires_rosetta
  end
end