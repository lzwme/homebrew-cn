cask "praat" do
  version "6.4.36,6436"
  sha256 "e7b8d82fc7530743beaa8f65151b789d4950642360d0153c48eeb16ec38ed3e4"

  url "https:github.compraatpraatreleasesdownloadv#{version.csv.first}praat#{version.csv.second}_mac.dmg",
      verified: "github.compraatpraat"
  name "Praat"
  desc "Doing phonetics by computer"
  homepage "https:praat.org"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)praat(\d+)[._-]mac\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  app "Praat.app"
  binary "#{appdir}Praat.appContentsMacOSPraat", target: "praat"

  zap trash: [
    "~LibraryPreferencesPraat Prefs",
    "~LibrarySaved Application Stateorg.praat.Praat.savedState",
  ]
end